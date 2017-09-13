class CheckinReminderJob
  require 'sidekiq/api'
  include Sidekiq::Worker

  def perform(profile_id, checkin_reminder_at)
    profile = Profile.find_by(id: profile_id)

    return unless profile
    return unless profile.checkin_reminder

    CheckinReminderMailer.remind(email: profile.email).deliver_later

    profile.update_column(:reminder_job_id, self.class.perform_in(24.hours, profile_id, checkin_reminder_at))
  end
end
