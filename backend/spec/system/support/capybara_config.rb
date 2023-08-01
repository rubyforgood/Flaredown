# Most of the config here, and in cuprite_config, was borrowed, with many thanks, from:
# https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing
Capybara.configure do |config|
  # Usually, especially when using Selenium, developers tend to increase the max wait time.
  # With Cuprite, there is no need for that.
  # We use a Capybara default value here explicitly.
  config.default_max_wait_time = 2

  # Normalize whitespaces when using `has_text?` and similar matchers,
  # i.e., ignore newlines, trailing spaces, etc.
  # That makes tests less dependent on slightly UI changes.
  config.default_normalize_ws = true

  # Where to store system tests artifacts (e.g. screenshots, downloaded files, etc.).
  # It could be useful to be able to configure this path from the outside (e.g., on CI).
  config.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")

  # Port on which to fire up the rails backend.
  config.server_port = ENV["SYSTEM_SPEC_BACKEND_PORT"]

  # Where to find frontend app; see ./frontend_app.rb
  config.app_host = "http://localhost:#{ENV["SYSTEM_SPEC_FRONTEND_PORT"]}"
end
