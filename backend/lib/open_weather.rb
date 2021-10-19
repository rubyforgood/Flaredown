class OpenWeather
  include HTTParty

  base_uri 'https://api.openweathermap.org/data/2.5'

  def self.api_key
    Rails.application.secrets.open_weather_api_key
  end

  def self.default_options
    { appid: api_key }
  end

  def current_weather(lat:, lon:, exclude: nil)
    self.class.get 'https://api.openweathermap.org/data/2.5/onecall', { query: self.class.default_options.merge(lat: lat, lon: lon, units: "imperial", exclude: "minutely,hourly,alerts") }
  end

  def timemachine(lat:, lon:, date:)
    self.class.get 'https://api.openweathermap.org/data/2.5/onecall/timemachine', { query: self.class.default_options.merge(lat: lat, lon: lon, dt: date, units: "imperial") }
  end
end
