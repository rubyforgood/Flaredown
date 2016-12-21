class WeatherRetriever
  def self.get(date, postal_code)
    weather = Weather.find_by(date: date, postal_code: postal_code)

    return weather if weather.present?

    position = Geocoder.search(postal_code).first

    forecast = ForecastIO.forecast(
      position.latitude,
      position.longitude,
      time: date.to_time.to_i,
      params: { exclude: 'minutely,hourly,alerts,flags' }
    )

    Weather.create(
      underscore_keys(permitted(forecast.daily.data.first)).merge(
        date: date,
        postal_code: postal_code
      )
    )
  end

  class << self
    private

    def underscore_keys(hash)
      hash.map { |k, v| [k.underscore, v] }.to_h
    end

    def permitted(hash)
      hash.slice(:icon, :temperatureMin, :temperatureMax, :precipIntensity, :pressure, :humidity)
    end
  end
end
