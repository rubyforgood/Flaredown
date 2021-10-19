class WeatherRetriever
  class << self
    def get(date, postal_code)
      position = Position.find_or_create_by(postal_code: postal_code)

      weather = Weather.find_by(date: date, position_id: position.id)

      return weather if weather.present?

      if position&.latitude.blank? || position&.longitude.blank?
        Rails.logger.warn "No coordinates found for postal_code #{postal_code}: #{position.inspect}"

        return
      end

      past = false
      weather = if date == Date.today
        fetch_current_weather(position)
      else
        past = true
        fetch_past_weather(date, position)
      end

      the_day = if past
        weather["current"]
      else
        weather["daily"].first
      end

      if the_day.blank?
        Rails.logger.warn "No forecast found for position #{position.inspect}: #{forecast.inspect}"

        return
      end

      create_weather(the_day, position.id)
    end

    private

    def fetch_current_weather(position)
      OpenWeather.new.current_weather(
        lat: position.latitude,
        lon: position.longitude
      )
    end

    def fetch_past_weather(date, position)
      tz = Time.zone
      Time.zone = NearestTimeZone.to(position.latitude, position.longitude)

      weather = OpenWeather.new.timemachine(
        lat: position.latitude,
        lon: position.longitude,
        date: date.to_time.to_i,
      )

      Time.zone = tz

      weather
    end

    def create_weather(the_day, position_id)
      Weather.create(
        date: Time.at(the_day["dt"]),
        humidity: the_day["humidity"],
        icon: the_day["weather"].first["icon"], # build icon url instead
        position_id: position_id,
        precip_intensity: the_day["rain"].is_a?(Hash) ? the_day["rain"]["1h"] : the_day["rain"],
        pressure: the_day["pressure"],
        summary: the_day["weather"].first["description"],
        temperature_max: the_day["temp"].is_a?(Hash) ? the_day["temp"]["max"] : the_day["temp"],
        temperature_min: the_day["temp"].is_a?(Hash) ? the_day["temp"]["min"] : the_day["temp"]
      )
    end
  end
end
