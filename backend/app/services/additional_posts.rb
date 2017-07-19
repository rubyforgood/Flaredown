class AdditionalPosts
  protected

  def current_ability
    @current_ability ||= Ability.new(user)
  end

  def add_last_new_posts(number, followed_ids)
    Post.where(_type: 'Post')
      .not_in(:_id => followed_ids) # rubocop:disable Style/HashSyntax
      .order(created_at: :desc)
      .to_a
      .first(number)
  end
end
