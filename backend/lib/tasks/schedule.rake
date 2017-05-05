desc "Schedule NotificationDispatcher"
namespace :notification do
  task dispatcher: :environment do
    p "NotificationDispatcher starts"
    Notification.distinct(:encrypted_notify_user_id).each do |encrypted_id|
      GroupNotifiersPerUser.perform_async(encrypted_id)
    end
    p "done."
  end
end
