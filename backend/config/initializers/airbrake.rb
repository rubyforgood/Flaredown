Airbrake.configure do |config|
  config.ignore_environments = %w(development test)
  config.host = ENV['AIRBRAKE_HOST']
  config.project_id = ENV['AIRBRAKE_PROJECT_ID']
  config.project_key = ENV['AIRBRAKE_PROJECT_KEY']
end
