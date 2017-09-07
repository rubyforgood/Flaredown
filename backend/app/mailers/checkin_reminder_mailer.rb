class CheckinReminderMailer < ApplicationMailer
  layout 'mailer_layout'

  def remind(notification_hash)
    @email = notification_hash[:email]
    notify_token = User.find_by(email: @email).notify_token
    return unless notify_token
    @click_here_link = Rails.application.secrets.base_url

    mail(to: @email, subject: "Time to check in to Flaredown")
  end
end
