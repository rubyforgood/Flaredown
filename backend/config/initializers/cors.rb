# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true, logger: -> { Rails.logger } do
  allow do
    origins ENV['BASE_URL'], ENV['DOMAIN_NAME']
    resource '*', headers: :any, methods: %i(get post options put patch delete head)
  end
end
