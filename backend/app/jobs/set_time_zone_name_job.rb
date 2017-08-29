class SetTimeZoneNameJob < ApplicationJob
  queue_as :default

  def perform(position_id)
    position = Position.find_by(id: position_id)
    return unless position.present?

    timezone_name = NearestTimeZone.to(position.latitude, position.longitude)

    position.update_attributes(time_zone_name: timezone_name)
  end
end
