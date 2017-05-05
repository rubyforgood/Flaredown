class NotificationsMailer < ApplicationMailer
  layout 'mailer_layout'

  helper_method :resource_title, :resource_url

  def notify(notification_hash)
    @email = notification_hash[:email]
    @data = notification_hash[:data]

    mail(to: @email)
  end

  def resource_title(object_id, klass="Post")
    "#{klass.constantize.find(object_id).title}"
  end

  def resource_url(object_id, klass="Post")
    ["#{ENV['BASE_URL']}", "#{klass.tableize}", "#{object_id}"].join('/')
  end
end
