class CheckinReminderJob
  include Sidekiq::Worker

  # run every hour
  def perform
    Profile.where(checkin_reminder: true).where.not(position_id: nil).batch_size(500).each do |profile|
      return unless profile.time_zone_name.present?

      TimeZoneDispatcher.perform_async(profile.id, profile.reminder_job_id)
    end
  end
end
