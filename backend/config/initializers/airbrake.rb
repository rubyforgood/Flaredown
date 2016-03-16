Airbrake.configure do |config|
  config.host = ENV['AIRBRAKE_HOST']
  config.project_id = ENV['AIRBRAKE_PROJECT_ID']
  config.project_key = ENV['AIRBRAKE_PROJECT_KEY']
end if Flaredown.config.airbrake_enabled?
