class ApplicationMailer < ActionMailer::Base
  default from: ENV["SMTP_EMAIL_FROM"]

  REGEXP = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i

  def valid_email?(email)
    email =~ REGEXP
  end
end
