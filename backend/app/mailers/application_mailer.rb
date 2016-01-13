class ApplicationMailer < ActionMailer::Base
  default from: ENV['SMTP_EMAIL_FROM']
  layout 'mailer'
end
