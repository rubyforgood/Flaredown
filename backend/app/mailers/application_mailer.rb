class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.smtp_email_from

  REGEXP = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i

  def valid_email?(email)
    email =~ REGEXP
  end
end
