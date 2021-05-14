ActionMailer::Base.default_url_options = {host: ENV["BASE_URL"]}

ActionMailer::Base.smtp_settings = {
  port: ENV["SMTP_PORT"],
  address: ENV["SMTP_ADDRESS"],
  user_name: ENV["SMTP_USER"],
  password: ENV["SMTP_PASS"],
  domain: ENV["SMTP_DOMAIN"],
  authentication: :login
}
