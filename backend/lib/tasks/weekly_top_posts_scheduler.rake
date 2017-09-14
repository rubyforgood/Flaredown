namespace :weekly_top_posts do
  desc "Schedule TopPostsMailerDispatcher"
  task dispatcher: :environment do
    TopPostsMailerDispatcher.perform_async
  end
end
