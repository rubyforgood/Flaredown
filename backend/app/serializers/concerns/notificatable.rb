module Notificatable
  extend ActiveSupport::Concern

  included do
    attributes :notifications
  end

  def notifications
    object.notifications.aggregated_notifications
  end
end
