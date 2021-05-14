class UpdateCheckinReminders
  require "sidekiq/api"

  include Sidekiq::Worker

  def perform(profile_id)
    profile = Profile.find_by(id: profile_id)

    return unless profile
    return unless profile.checkin_reminder && profile.checkin_reminder_at

    Sidekiq::ScheduledSet.new.find_job(profile.reminder_job_id)&.delete

    job_id = CheckinReminderJob.perform_in(get_reminder_time(profile).minutes, profile_id, profile.checkin_reminder_at)
    profile.update_column(:reminder_job_id, job_id)
  end

  def get_reminder_time(profile)
    time_zone_name = profile.time_zone_name
    checkin_at_timezone = profile.checkin_reminder_at.strftime("%H:%M").in_time_zone(time_zone_name)

    # Select minutes
    (checkin_at_timezone - Time.current.in_time_zone(time_zone_name)).divmod(1.day)[1].divmod(1.minute)[0]
  end
end
