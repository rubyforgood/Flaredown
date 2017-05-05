desc "Schedule NotificationDispatcher"
namespace :notification do
  task dispatcher: :environment do
    sh sh_script
  end

  def sh_script
    Rails.env.production? ? "heroku run crono RAILS_ENV=#{Rails.env} --app #{ENV['APP_NAME']}" : "bundle exec crono RAILS_ENV=#{Rails.env}"
  end
end
