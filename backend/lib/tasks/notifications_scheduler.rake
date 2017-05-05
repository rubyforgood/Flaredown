namespace :notification do
  desc "Schedule NotificationDispatcher"
  task dispatcher: :environment do
    NotificationDispatcher.perform_async
  end
end
