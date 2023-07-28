# First, load Cuprite Capybara integration
require "capybara/cuprite"

# Then, we need to register our driver to be able to use it later
# with #driven_by method.
# NOTE: The name :cuprite is already registered by Rails.
# See https://github.com/rubycdp/cuprite/issues/180
Capybara.register_driver(:better_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{ # TODO: just inline?
      window_size:     [1200, 800],
      browser_options: {},
      process_timeout: 10,
      inspector:       true,
      headless:        ENV["HEADLESS_CHROME"] != "false"
    }
  )
end

# Configure Capybara to use :better_cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
