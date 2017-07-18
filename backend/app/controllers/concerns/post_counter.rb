module PostCounter
  extend ActiveSupport::Concern

  protected

  def update_post_counters(params)
    post = Post.find_by(_id: params[:parent_id], _type: params[:parent_type] )
    post&.update_counters
  end
end
