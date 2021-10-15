Bugsnag.configure do |config|
  config.api_key = ENV["BUGSNAG_API_KEY"]
  config.release_stage = ENV["BUGSNAG_RELEASE_STAGE"] || ENV["RAILS_ENV"]
end
