class WeatherRetriever
  def self.get(date, postal_code)
    weather = Weather.find_by(date: date, postal_code: postal_code)

    return weather if weather.present?

    position = Geocoder.search(postal_code).first
    tz = Time.zone
    Time.zone = NearestTimeZone.to(position.latitude, position.longitude)

    forecast = ForecastIO.forecast(
      position.latitude,
      position.longitude,
      time: Time.zone.parse(date.to_s).to_i,
      params: { exclude: 'currently,minutely,hourly,alerts,flags' }
    )

    Time.zone = tz

    if Rails.application.secrets.debug
      Rails.logger.info("\nThe forecast for #{date} and #{postal_code} is:\n#{forecast.to_yaml}\n")
    end

    the_day = forecast.daily.data.first

    Weather.create(
      date: Date.strptime(the_day.time.to_s, '%s'),
      humidity: (the_day.humidity * 100).round,
      icon: the_day.icon,
      postal_code: postal_code,
      precip_intensity: the_day.precipIntensity,
      pressure: the_day.pressure.round,
      summary: the_day.summary,
      temperature_max: the_day.temperatureMax.round,
      temperature_min: the_day.temperatureMin.round
    )
  end
end
