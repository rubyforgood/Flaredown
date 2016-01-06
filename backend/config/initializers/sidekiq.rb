Sidekiq.configure_server do |config|
  config.redis = { url: Flaredown.config.redis_url, size: 4, db: ENV['REDIS_DB'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Flaredown.config.redis_url, size: 1, db: ENV['REDIS_DB'] }
end
