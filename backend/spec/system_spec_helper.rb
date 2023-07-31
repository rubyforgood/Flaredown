require "rails_helper"

# Most of the system spec config was borrowed, with many thanks, from:
# https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing
require "system/support/frontend_app"
require "system/support/capybara_config"
require "system/support/cuprite_config"

RSpec.configure do |config|
  config.prepend_before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end

  # System specs are excluded by default in ~/.rspec
  # bin/system_spec provides a thin shim that includes them
  unless config.exclusion_filter[:type] == "system"
    config.before(:suite) do
      SystemSpec::FrontendApp.instance.start
    end

    config.after(:suite) do
      SystemSpec::FrontendApp.instance.stop
    end
  end
end
