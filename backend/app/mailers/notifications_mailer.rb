class NotificationsMailer < ApplicationMailer
  layout "mailer_layout"

  helper_method :resource_title, :resource_url

  def notify(notification_hash)
    @email = notification_hash[:email]
    return unless valid_email?(@email)

    @unsubscribe_link = Rails.application.secrets.base_url + "/unsubscribe/#{User.find_by(email: @email).notify_token}"
    @data = notification_hash[:data]

    mail(to: @email, subject: "New response to your Flaredown message")
  end

  def resource_title(object_id, class_name = "Post")
    class_name.constantize.find(object_id).title.to_s
  end

  def resource_url(object_id, class_name = "Post")
    [ENV["BASE_URL"], class_name.tableize, object_id].map(&:to_s).join("/")
  end
end
