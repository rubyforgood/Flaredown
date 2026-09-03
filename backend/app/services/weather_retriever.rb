require "digest"

class WeatherRetriever
  FORECAST_MISS_TTL = 5.minutes

  class << self
    def get(date, postal_code)
      date = date.to_date
      position = find_or_create_position(postal_code)

      if position.persisted?
        weather = Weather.find_by(date: date, position_id: position.id)

        return weather if weather.present?
      end

      if position&.latitude.blank? || position&.longitude.blank?
        Rails.logger.warn "No coordinates found for weather position"

        return
      end

      return if forecast_miss_cached?(date, position.id)

      if historical_date?(date, position)
        Rails.logger.warn "No forecast for #{date} at position #{position.id}: the date is before the position's current day"

        return
      end

      # Do not hold a database transaction open while waiting on the weather
      # vendor. Concurrent misses may fetch the same forecast, but the short lock
      # below still makes their final cache write converge on one record.
      forecast = get_forecast(position)

      if forecast.status != 200
        Rails.logger.warn "No forecast found for position #{position.id}: response code was #{forecast.status}"
        cache_forecast_miss(date, position.id)

        return
      end

      day = daily_forecast_on(forecast, date, position)

      if day.blank?
        Rails.logger.warn "No forecast for #{date} at position #{position.id}: the date is outside the forecast window"
        cache_forecast_miss(date, position.id)

        return
      end

      # The existing unique index on (date, postal_code) cannot arbitrate these
      # writes because current records are keyed by position_id and leave
      # postal_code nil. Until a unique (date, position_id) index can replace it,
      # serialize just the final cache recheck and write.
      position.with_lock do
        weather = Weather.find_by(date: date, position_id: position.id)

        return weather if weather.present?

        create_weather(day, date, position.id)
      end
    end

    private

    # Position has no unique postal_code index, so a row lock cannot protect the
    # instant before that row exists. A transaction-scoped advisory lock on a
    # one-way location hash makes first creation converge on one row without
    # putting the submitted address in SQL logs.
    def find_or_create_position(postal_code)
      Position.transaction(requires_new: true) do
        lock_id = Digest::SHA256.digest(postal_code.to_s).unpack1("q>")
        Position.connection.execute("SELECT pg_advisory_xact_lock(#{lock_id})")
        Position.find_or_create_by(postal_code: postal_code)
      end
    end

    def get_forecast(position)
      Tomorrowiorb.forecast(
        "#{position.latitude},#{position.longitude}",
        ["1d"],
        "imperial"
      )
    end

    # The forecast endpoint takes no date: it always answers with a daily timeline
    # starting at the position's today. Pick out the day that was actually asked
    # for -- comparing dates in the position's own time zone, since the timeline
    # stamps each day in UTC -- so that the record we store is keyed by the date
    # the caller wanted and the cache above can find it again. Days outside the
    # window (a back-filled check-in, say) have no forecast to store.
    def daily_forecast_on(forecast, date, position)
      daily = JSON.parse(forecast.body, symbolize_names: true).dig(:timelines, :daily) || []
      time_zone = time_zone_for(position)

      daily.find { |day| local_date(day[:time], time_zone) == date }
    end

    def historical_date?(date, position)
      date < Time.current.in_time_zone(time_zone_for(position)).to_date
    end

    def time_zone_for(position)
      NearestTimeZone.to(position.latitude.to_f, position.longitude.to_f).presence || "UTC"
    end

    def forecast_miss_cached?(date, position_id)
      Rails.cache.read(forecast_miss_cache_key(date, position_id)) == true
    end

    def cache_forecast_miss(date, position_id)
      Rails.cache.write(
        forecast_miss_cache_key(date, position_id),
        true,
        expires_in: FORECAST_MISS_TTL
      )
    end

    def forecast_miss_cache_key(date, position_id)
      "weather_retriever/forecast_miss/#{position_id}/#{date.iso8601}"
    end

    def local_date(time, time_zone)
      Time.parse(time.to_s).in_time_zone(time_zone).to_date
    rescue ArgumentError
      nil
    end

    def create_weather(day, date, position_id)
      values = day.dig(:values)
      rain_intensity = values.dig(:rainIntensityAvg)
      sleet_intensity = values.dig(:sleetIntensityAvg)
      snow_intensity = values.dig(:snowIntensityAvg)
      icon = get_icon_legacy(values)
      summary = "General conditions are #{icon}, with an average temperature of #{values[:temperatureAvg]}."
      weather = Weather.new(
        date: date,
        humidity: values.dig(:humidityAvg).round,
        icon: icon,
        position_id: position_id,
        precip_intensity: rain_intensity + sleet_intensity + snow_intensity,
        pressure: values.dig(:pressureSurfaceLevelAvg),
        summary: summary,
        temperature_max: values.dig(:temperatureMax),
        temperature_min: values.dig(:temperatureMin)
      )

      return weather if weather.save

      Rails.logger.warn "Could not store weather for #{date} at position #{position_id}: #{weather.errors.full_messages.to_sentence}"

      # Do not hand callers an unsaved record whose nil id would be persisted as
      # "this check-in has no weather". The lookup also tolerates a writer that
      # does not participate in the position-row locking protocol above.
      Weather.find_by(date: date, position_id: position_id)
    end

    def get_icon_legacy(values)
      # Our icons do not coverage their full range of weather codes. We could pull in their icons (linked below) on the frontend to expand options
      # This method adapts their weather codes to our existing icons as best as possible
      # Icons and codes found here: https://docs.tomorrow.io/reference/data-layers-weather-codes
      # Icon files here: https://github.com/Tomorrow-IO-API/tomorrow-weather-codes
      # Daily forecast is always daytime weather codes / icons regardless of actual time
      # The forecast body is parsed with symbolized names, so these keys are symbols
      code = if values[:weatherCodeMin]
        values[:weatherCodeMin]
      elsif values[:weatherCodeFullDay]
        values[:weatherCodeFullDay]
      else
        values[:weatherCode]
      end

      case code
      when 1000, 1100
        "clear-day"
      when 1101
        "partly-cloudy-day"
      when 1102, 1001, 8000
        "cloudy"
      when 2000, 2100
        "fog"
      when 4000, 4001, 4200, 4201
        "rain"
      when 5000, 5001, 5100, 5101
        "snow"
      when 6000, 6001, 6200, 6201, 7000, 7101, 7102
        "sleet"
      else
        "default"
      end
    end
  end
end
