class TopPostsMailer < ApplicationMailer
  layout 'mailer_layout'

  def notify(mailer_hash)
    @email = mailer_hash[:email]
    return unless valid_email?(@email)

    @unsubscribe_link =
      Rails.application.secrets.base_url + "/unsubscribe/#{mailer_hash[:notify_token]}?notify_top_posts=false"
    @top_posts = Post.where(_type: 'Post', :_id.in => mailer_hash[:top_posts_ids])

    mail(to: @email, subject: 'Weekly "top posts"')
  end
end
