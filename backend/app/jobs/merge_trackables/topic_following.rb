class MergeTrackables::TopicFollowing
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    trackable_key = "#{trackable_type}_ids"

    TopicFollowing.all(trackable_key.to_sym.in => rest_ids).map do |tf|
      updated_ids = tf.send(trackable_key) - rest_ids + [parent_id]

      tf.update_attributes(trackable_key.to_sym => updated_ids.uniq)
    end

    p "PERFORM MergeTrackables::CheckinTrackables"

    MergeTrackables::CheckinTrackables.perform_async(trackable_type, parent_id, rest_ids)
  end
end
