class GroupTopPostsJob
  include Sidekiq::Worker

  def perform(notify_token)
    profile = Profile.find_by(notify_token: notify_token)
    user = profile&.user

    return unless profile && profile.notify_top_posts && user
    return if user&.rejected_type.present? # Rejected via AWS SES

    top_posts_ids = DiscussionPosts.new(nil, user).refined_top_list.map(&:id).map(&:to_s)
    TopPostsMailer.notify(email: user.email, notify_token: notify_token, top_posts_ids: top_posts_ids).deliver_later
  end
end
