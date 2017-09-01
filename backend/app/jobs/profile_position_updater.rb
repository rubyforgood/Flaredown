class ProfilePositionUpdater
  include Sidekiq::Worker

  def perform(profile_id, position_id)
    @profile = Profile.find_by(id: profile_id)
    return if @profile.position_id == position_id

    @profile.update_attributes(position_id: position_id, checkin_reminder_at: updated_checkin_reminder)
  end

  def updated_checkin_reminder
    @profile.checkin_reminder_at.strftime('%H:%M').in_time_zone(@profile.time_zone_name).utc
  end
end
