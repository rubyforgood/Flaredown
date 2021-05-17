class UpdatePostCountersJob
  include Sidekiq::Worker

  def perform(params)
    parent_type = params["parent_type"]
    return unless parent_type == "Post"

    post = Post.find_by(_id: params["parent_id"], _type: parent_type)
    return unless post

    post&.update_counters
  end
end
