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
      the_day = forecast&.daily&.data&.first

      if the_day.blank?
        Rails.logger.warn "No forecast found for position #{position.inspect}: #{forecast.inspect}"

        return
      end

      create_weather(the_day, position.id)
    end

    private

    def get_forecast(date, position)
      tz = Time.zone
      Time.zone = NearestTimeZone.to(position.latitude, position.longitude)

      forecast = ForecastIO.forecast(
        position.latitude,
        position.longitude,
        time: Time.zone.parse(date.to_s).to_i,
        params: { exclude: 'currently,minutely,hourly,alerts,flags' }
      )

      Time.zone = tz

      forecast
    end

    def create_weather(the_day, position_id)
      Weather.create(
        date: Date.strptime(the_day.time.to_s, '%s'),
        humidity: (the_day.humidity * 100).round,
        icon: the_day.icon,
        position_id: position_id,
        precip_intensity: the_day.precipIntensity,
        pressure: the_day.pressure.round,
        summary: the_day.summary,
        temperature_max: the_day.temperatureMax.round,
        temperature_min: the_day.temperatureMin.round
      )
    end
  end
end
