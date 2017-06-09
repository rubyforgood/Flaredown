class DiscussionMentionMailer < ApplicationMailer
  layout 'mailer_layout'

  def notify(username, email)
    @email = email
    @author = username

    mail(to: @email, subject: "You have been mentioned")
  end
end
