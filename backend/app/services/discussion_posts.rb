class DiscussionPosts
  attr_accessor :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def show_list
    posts = Post.accessible_by(current_ability).where(_type: 'Post')
    posts = posts.fts(params[:query]) if params[:query].present?
    posts = if params[:id].present? && Post::TOPIC_TYPES.include?(params[:type])
              posts.where("#{params[:type]}_ids": params[:id].to_i)
            elsif params[:following].present?
              posts.by_followings(user.topic_following)
            else
              posts
            end
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(user)
  end
end
