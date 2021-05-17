class PusherClient
  include Singleton

  def initialize
    Pusher.app_id = ENV["PUSHER_APP_ID"]
    Pusher.key = ENV["PUSHER_KEY"]
    Pusher.secret = ENV["PUSHER_SECRET"]
  end

  def push(channel, event, message)
    Pusher.trigger(channel, event, ActiveSupport::JSON.encode(message))
  end

  def authenticate!(user, socket_id)
    Pusher[user.notification_channel].authenticate(socket_id, user_id: user.id)
  end
end
