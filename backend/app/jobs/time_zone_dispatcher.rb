class TimeZoneDispatcher
  include Sidekiq::Worker

  def perform(profile_id)
    profile = Profile.find_by(id: profile_id)
    return unless profile.time_zone_name.present?

    # reminder_in_utc = profile.checkin_reminder_at.in_time_zone(profile.time_zone_name).utc

    diff_minutes = time_comparison(profile.checkin_reminder_at.utc)

    if diff_minutes >= 0
      RemindMailerJob.perform_in(diff_minutes.minutes, profile.user.email)
    end
  end

  protected

  def time_comparison(user_time_utc)
    (Time.current.utc - user_time_utc).divmod(60)[0] # Select minutes
  end
end
