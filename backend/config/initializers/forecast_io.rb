ForecastIO.configure do |c|
  c.api_key = Rails.application.secrets.forecast_io_key
end
