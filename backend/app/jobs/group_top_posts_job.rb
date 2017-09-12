class GroupTopPostsJob
  include Sidekiq::Worker

  def perform(notify_token)
    profile = Profile.find_by(notify_token: notify_token)
    user = profile&.user

    return unless profile && profile.notify_top_posts && user

    top_posts_ids = DiscussionPosts.new(params=nil, user).refined_top_list.map(&:id).map(&:to_s)
    TopPostsMailer.notify(email: user.email, notify_token: notify_token, top_posts_ids: top_posts_ids).deliver_later
  end
end
