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

    def similarity_tolerance
      '0.1'
    end

    def trackables_min_popularity
      3
    end

    def airbrake_enabled?
      ENV['AIRBRAKE_ENABLED'].present? && ENV['AIRBRAKE_ENABLED'].to_s.eql?("true")
    end

  end
end
