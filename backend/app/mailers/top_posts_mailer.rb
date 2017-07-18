class TopPostsMailer < ApplicationMailer
  layout 'mailer_layout'

  def notify(notification_hash)
    @email = notification_hash[:email]
    @unsubscribe_link = Rails.application.secrets.base_url + "/unsubscribe/#{notification_hash[:notify_token]}?notify_top_posts=false"

    mail(to: @email, subject: 'Weekly "top posts"')
  end
end
