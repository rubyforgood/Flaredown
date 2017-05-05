class NotificationDispatcher
  def perform
    Notification.distinct(:encrypted_notify_user_id).each do |encrypted_id|
      GroupNotifiersPerUser.perform_async(encrypted_id)
    end
  end
end
