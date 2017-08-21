class WeatherSerializer < ApplicationSerializer
  attributes :id, :humidity, :icon, :precip_intensity, :pressure, :summary, :temperature_max, :temperature_min
end
