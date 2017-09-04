class GroupTopPostsJob
  include Sidekiq::Worker

  def perform(params_hash)
    notify_token = params_hash["notify_token"]
    user = Profile.find_by(notify_token: notify_token)&.user

    return unless user

    top_posts_ids = DiscussionPosts.new(params_hash, user).refined_top_list.map(&:id).map(&:to_s)
    TopPostsMailer.notify(email: user.email, notify_token: notify_token, top_posts_ids: top_posts_ids).deliver_later
  end
end
