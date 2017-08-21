class WeatherSerializer < ApplicationSerializer
  attributes :id, :humidity, :icon, :precip_intensity, :pressure, :summary, :temperature_max, :temperature_min, :postal_code

  def postal_code
    object.position&.postal_code
  end
end
