class NotificationsMailer < ApplicationMailer
  layout 'mailer_layout'

  helper_method :resource_title, :resource_url

  def notify(notification_hash)
    @email = notification_hash[:email]
    @data = notification_hash[:data]

    mail(to: @email)
  end

  def resource_title(object_id, class_name = 'Post')
    class_name.constantize.find(object_id).title.to_s
  end

  def resource_url(object_id, class_name = 'Post')
    [ENV['BASE_URL'], class_name.tableize, object_id].map(&:to_s).join('/')
  end
end
