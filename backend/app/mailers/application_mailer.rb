class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.smtp_email_from
end
