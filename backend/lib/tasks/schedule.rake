desc "Schedule NotificationDispatcher"
namespace :notification do
  task dispatcher: :environment do
    sh "bundle exec crono RAILS_ENV=#{Rails.env}"
  end
end
