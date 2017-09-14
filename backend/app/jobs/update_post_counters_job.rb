class UpdatePostCountersJob
  include Sidekiq::Worker

  def perform(params)
    post = Post.find_by(_id: params['parent_id'], _type: params['parent_type'])
    return unless post

    post&.update_counters
  end
end
