class OpenWeather
  include HTTParty

  base_uri 'https://api.openweathermap.org/data/2.5'

  def api_key
    Rails.application.secrets.open_weather_api_key
  end

  def default_options
    { api_key: api_key }
  end

  def current_weather(lat:, lon:, exclude: nil)
    self.class.get '/onecall', lat: lat, lon: lon, exclude: exclude
  end

  def self.get(path, options)
    super path, default_options.merge(options)
  end
end
