module Flaredown
  def self.config
    Flaredown::Settings.instance
  end

  def self.session
    Flaredown::Session.instance
  end

  def self.pusher
    PusherClient.instance
  end

  class Session
    include Singleton, ActiveModel::Serialization
  end

  class Settings
    include Singleton

    def redis_url
      ENV['REDISCLOUD_URL'].present? ? ENV['REDISCLOUD_URL'] : ENV['REDIS_URL']
    end

    def trackables_min_popularity
      3
    end

    def discourse_enabled?
      !!(Rails.env.production? || ENV.fetch('DISCOURSE_ENABLED') { false })
    end

    def discourse_url
      ENV.fetch('DISCOURSE_URL')
    end
  end
end
