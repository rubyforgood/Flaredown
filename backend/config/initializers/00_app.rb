module Flaredown

  def self.config
    Settings.instance
  end

  class Settings
    include Singleton

    def redis_url
      ENV["REDISCLOUD_URL"].present? ? ENV['REDISCLOUD_URL'] : ENV['REDIS_URL']
    end
  end

end
