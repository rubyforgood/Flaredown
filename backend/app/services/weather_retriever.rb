class WeatherRetriever
  class << self
    def get(date, postal_code)
      position = Position.find_or_create_by(postal_code: postal_code)

      weather = Weather.find_by(date: date, position_id: position&.id)

      return weather if weather.present?

      if position&.latitude.blank? || position&.longitude.blank?
        Rails.logger.warn "No coordinates found for postal_code #{postal_code}: #{position.inspect}"

        return
      end

      forecast = get_forecast(date, position)

      if forecast.status != 200
        Rails.logger.warn "No forecast found for position #{position.inspect}: response code was #{forecast.status}, headers were #{forecast.headers}, body contained #{forecast.body}"

        return
      end

      create_weather(forecast, position.id)
    end

    private

    def get_forecast(date, position)
      Tomorrowiorb.forecast(
        "#{position.latitude},#{position.longitude}",
        ["1d"],
        "metric"
      )
    end

    def create_weather(forecast, position_id)
      today = forecast.body.dig(:timelines, :daily, 0)
      the_time = today.dig(:time)
      rain_intensity = today.dig(:rainIntensity)
      sleet_intensity = today.dig(:sleetIntensity)
      snow_intensity = today.dig(:snowIntensity)
      icon = get_icon_legacy(today)
      summary = "General conditions are #{icon}, with an average temperature of #{today["temperatureAvg"]}."

      Weather.create(
        date: Date.strptime(the_time, "%Y-%m-%d"),
        humidity: today.dig(:humidityAvg).round,
        icon: icon,
        position_id: position_id,
        precip_intensity: rain_intensity + sleet_intensity + snow_intensity,
        pressure: today.dig(:pressureSurfaceLevel),
        summary: summary,
        temperature_max: today.dig(:temperatureMax),
        temperature_min: today.dig(temperatureMin)
      )
    end

    def get_icon_legacy(today)
      # Our icons do not coverage their full range of weather codes. We could pull in their icons (linked below) on the frontend to expand options
      # This method adapts their weather codes to our existing icons as best as possible
      # Icons and codes found here: https://docs.tomorrow.io/reference/data-layers-weather-codes
      # Icon files here: https://github.com/Tomorrow-IO-API/tomorrow-weather-codes
      # Daily forecast is always daytime weather codes / icons regardless of actual time
      code = if today["weatherCodeMin"]
        today["weatherCodeMin"]
      elsif today["weatherCodeFullDay"]
        today["weatherCodeFullDay"]
      else
        today["weatherCode"]
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
