class TopPostsMailerDispatcher
  include Sidekiq::Worker

  TOP_POST_WEEKLY_TIME = ENV['TOP_POST_WEEKLY_TIME']
  MAX_DIFF = 5.minutes

  def perform
    # return unless Time.current.tuesday? # Send on tuesdays
    return unless Time.current.wednesday? || Time.current.thursday? # Send on tuesdays

    Profile.where(notify_top_posts: true, time_zone_name: find_time_zone_names).find_each(batch_size: 500) do |profile|
      GroupTopPostsJob.perform_async(profile.notify_token)
    end
  end

  def find_time_zone_names
    Profile.pluck(:time_zone_name).compact.uniq.select do |time_zone_name|
      (Time.current.in_time_zone(time_zone_name) - TOP_POST_WEEKLY_TIME.in_time_zone(time_zone_name)).abs < MAX_DIFF
    end
  end
end
