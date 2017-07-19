class DiscussionPosts < AdditionalPosts
  attr_accessor :params, :user

  TOP_POSTS_DAYS  = 7
  TOP_POSTS_COUNT = 5

  def initialize(params, user)
    @params = params
    @user = user
  end

  def show_list
    return Post.none unless params

    @posts = Post.accessible_by(current_ability).where(_type: 'Post')
    @posts = @posts.fts(params[:query]) if params[:query].present?
    @posts = if params[:id].present? && Post::TOPIC_TYPES.include?(params[:type])
               @posts.where("#{params[:type]}_ids": params[:id].to_i)
             elsif params[:following].present?
               @posts.by_followings(user.topic_following)
             else
               @posts
             end
  end

  def full_top_post_list
    Post.accessible_by(current_ability)
      .where(_type: 'Post')
      .by_followings(user.topic_following)
      .where(:created_at.gte => TOP_POSTS_DAYS.days.ago)
      .order(total_count: :desc)
  end

  def refined_top_list
    posts = full_top_post_list.limit(TOP_POSTS_COUNT)

    if Array(posts).count == TOP_POSTS_COUNT
      posts
    else
      posts + add_last_new_posts(TOP_POSTS_COUNT - Array(posts).count, posts.map(&:_id))
    end
  end
end
