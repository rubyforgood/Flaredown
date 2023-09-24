require "spec_helper"

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :mongoid_model
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
