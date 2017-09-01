class CheckinReminderMailer < ApplicationMailer
  layout 'mailer_layout'

  def remind(notification_hash)
    @email = notification_hash[:email]
    notify_token = User.find_by(email: @email).notify_token
    return unless notify_token
    @unsubscribe_link = Rails.application.secrets.base_url + "/unsubscribe/#{notify_token}?stop_remind"

    mail(to: @email, subject: "Remind to checkin on Flaredown")
  end
end
