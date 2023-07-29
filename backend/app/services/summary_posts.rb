class SummaryPosts < AdditionalPosts
  attr_accessor :user, :topic_following, :posts

  SUMMARY_HOURS = 24.hours.ago.strftime("%Y-%m-%d")
  SUMMARY_POSTS = 3

  def initialize(user)
    @user = user
    @topic_following = user.topic_following
    @posts = Post.accessible_by(current_ability)
      .where(_type: "Post")
      .by_followings(@topic_following)
      .where(:created_at.gte => SUMMARY_HOURS)
  end

  def show_list
    posts = list.first(SUMMARY_POSTS)
    (posts.count == SUMMARY_POSTS) ? posts : posts + add_last_new_posts(SUMMARY_POSTS - posts.count, posts.map(&:_id))
  end

  def list
    topic_frequency.each_with_object([]) do |obj, array|
      array << Post.where(_type: "Post").find(obj[0])
      array.last.extend(PostExtender).frequency_topic_priority(topic_frequency[obj[0]])
    end
  end

  protected

  def topic_frequency
    posts.frequency_by(topic_following).sort_by { |_k, v| v }.reverse.to_h
  end
end
