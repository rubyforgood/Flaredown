# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.expect_with :rspec
  config.mock_with :rspec

  config.include Devise::TestHelpers, type: :controller

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    # TestEnv.init
  end
end

ActiveRecord::Migration.maintain_test_schema!
