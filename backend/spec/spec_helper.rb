require "simplecov"
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

Geocoder.configure(lookup: :test, ip_lookup: :test)
minneapolis_geo = {
  # match the WeatherRetriever vcr stub
  "coordinates" => [44.967486, -93.2897678],
  "address" => "Minneapolis, Minnesota, USA",
  "state" => "Minnesota",
  "state_code" => "MN",
  "country" => "United States",
  "country_code" => "US",
  "postal_code" => "55403"
}
Geocoder::Lookup::Test.set_default_stub([minneapolis_geo])

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.expect_with :rspec
  config.mock_with :rspec

  config.include Devise::Test::ControllerHelpers, type: :controller

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    # TestEnv.init
  end
end

ActiveRecord::Migration.maintain_test_schema!

# Every assertion helper in ActiveJob::TestHelper raises when the test adapter is
# missing, except `perform_enqueued_jobs` with a block: that one returns early and
# runs nothing, so a job spec would quietly assert nothing rather than fail. Rails
# 8.1 still behaves this way, so this guard is not a temporary workaround.
unless ActiveJob::Base.queue_adapter.is_a?(ActiveJob::QueueAdapters::TestAdapter)
  raise "Active Job is using #{ActiveJob::Base.queue_adapter.class}, not the test adapter. " \
    "`perform_enqueued_jobs` would silently do nothing. Set " \
    "`config.active_job.queue_adapter = :test` in config/environments/test.rb."
end
