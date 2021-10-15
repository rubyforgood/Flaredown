require File.expand_path("../boot", __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Flaredown
  class Application < Rails::Application
    # https://medium.com/@Nicholson85/handling-cors-issues-in-your-rails-api-120dfbcb8a24
    # fix CORS issues in staging?
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get, :post, :options, :put, :delete]
      end
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("lib/*")
    config.autoload_paths << Rails.root.join("lib/**/*")
    config.autoload_paths << Rails.root.join("app/serializers/concerns")
    config.autoload_paths << Rails.root.join("app/serializers/api/v1/concerns")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = false

    config.generators.orm :active_record

    config.active_record.schema_format = :sql

    # Be sure to have the adapter's gem in your Gemfile
    # and follow the adapter's specific installation
    # and deployment instructions.
    config.active_job.queue_adapter = :sidekiq
  end
end
