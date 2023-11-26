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
      forecast = Tomorrowiorb.forecast(
        "#{position.latitude},#{position.longitude}",
        ["1d"],
        "metric"
      )

      forecast
    end

    def create_weather(forecast, position_id)
      today = forecast.body["timelines"]["daily"][0]
      the_time = today["time"]
      rain_intensity = today["rainIntensity"]
      sleet_intensity = today["sleetIntensity"]
      snow_intensity = today["snowIntensity"]
      icon = get_icon_legacy(today)
      summary "General conditions are #{icon}, with an average temperature of #{today["temperatureAvg"].to_s}."

      Weather.create(
        date: Date.strptime(the_time, "%Y-%m-%d"),
        humidity: today["humidityAvg"].round,
        icon: ,
        position_id: position_id,
        precip_intensity: rain_intensity + sleet_intensity + snow_intensity,
        pressure: today["pressureSurfaceLevel"],
        summary: summary,
        temperature_max: today["temperatureMax"],
        temperature_min: today["temperatureMin"]
      )
    end

    def get_icon_legacy(today)
      # Our icons do not coverage their full range of weather codes. We could pull in their icons (linked below) on the frontend to expand options
      # This method adapts their weather codes to our existing icons as best as possible
      # Icons and codes found here: https://docs.tomorrow.io/reference/data-layers-weather-codes
      # Icon files here: https://github.com/Tomorrow-IO-API/tomorrow-weather-codes
      # Daily forecast is always daytime weather codes / icons regardless of actual time
      if today["weatherCodeMin"]
        code = today["weatherCodeMin"]
      elsif today["weatherCodeFullDay"]
        code = today["weatherCodeFullDay"]
      else
        code = today["weatherCode"]
      end
      
      case code
      when 1000, 1100
        return "clear-day"
      when 1101
        return "partly-cloudy-day"
      when 1102, 1001, 8000
        return "cloudy"
      when 2000, 2100
        return "fog"
      when 4000, 4001, 4200, 4201
        return "rain"
      when 5000, 5001, 5100, 5101
        return "snow"
      when 6000, 6001, 6200, 6201, 7000, 7101, 7102
        return "sleet"
      else
        return "default"
      end
    end
  end
end
