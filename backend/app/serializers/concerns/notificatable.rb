module Notificatable
  extend ActiveSupport::Concern

  included do
    attributes :notifications
  end

  def notifications
    return unless current_user
    object.notifications.where(encrypted_notify_user_id: current_user.encrypted_id).count_by_types
  end
end
