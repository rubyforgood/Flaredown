class MergeTrackables::PostTrackables
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    trackable_key = "#{trackable_type}_ids"

    Post.where(trackable_key.to_sym.in => rest_ids).map do |post|
      updated_ids = post.send(trackable_key) - rest_ids + [parent_id]

      post.update(trackable_key.to_sym => updated_ids.uniq)
    end

    p "PERFORM MergeTrackables::RemoveDuplicates"

    MergeTrackables::RemoveDuplicates.perform_async(trackable_type, rest_ids)
  end
end
