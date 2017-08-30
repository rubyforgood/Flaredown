class CheckinReminderJob
  include Sidekiq::Worker

  # run every 24h
  def perform
    Profile.where(checkin_reminder: true).where.not(position_id: nil).each do |profile|
      TimeZoneDispatcher.perfom_async(profile.id)
    end
  end
end
