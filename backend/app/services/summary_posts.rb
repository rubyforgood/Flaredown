class SummaryPosts
  attr_accessor :user, :topic_following, :posts

  SUMMARY_HOURS = 24.hours.ago.strftime("%Y-%m-%d")
  SUMMARY_POSTS = 5

  def initialize(user)
    @user = user
    @topic_following = user.topic_following
    @posts =
      Post.where(_type: 'Post')
      .by_followings(@topic_following)
      .where(:created_at.gte => SUMMARY_HOURS)
  end

  def show_list
    posts = list.first(SUMMARY_POSTS)
    posts.count == SUMMARY_POSTS ? posts : posts + add_last_new_posts(SUMMARY_POSTS - posts.count, posts.map(&:_id))
  end

  def list
    topic_frequency.each_with_object([]) do |obj, array|
      array << Post.where(_type: 'Post').find(obj[0])
      array.last.extend(PostExtender).frequency_topic_priority(topic_frequency[obj[0]])
    end
  end

  protected

  def topic_frequency
    posts.frequency_by(topic_following)
  end

  # def filter_posts
  #   Post.where(:_id.in => topic_frequency.keys)
  # end

  def add_last_new_posts(number, followed_ids)
    Post
    .where(_type: 'Post')
    .not_in(:_id => followed_ids)
    .order(created_at: :desc)
    .to_a
    .first(number)
  end
end
