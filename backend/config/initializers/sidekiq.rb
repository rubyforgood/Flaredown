Sidekiq.configure_server do |config|
  config.redis = { url: Flaredown.config.redis_url, db: ENV['REDIS_DB'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Flaredown.config.redis_url, db: ENV['REDIS_DB'] }
end
