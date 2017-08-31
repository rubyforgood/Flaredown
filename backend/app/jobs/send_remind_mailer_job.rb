class SendRemindMailerJob
  include Sidekiq::Worker

  def perform(email)
    CheckinReminderMailer.remind(email: email).deliver_now
  end
end
