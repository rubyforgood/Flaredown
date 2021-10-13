class MergeTrackables::Trackings
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    Tracking.where(trackable_id: rest_ids, trackable_type: trackable_type.camelcase).map do |tracking|
      tracking.update(trackable_id: parent_id)
    end

    p "PERFORM MergeTrackables::TopicFollowing"

    MergeTrackables::TopicFollowing.perform_async(trackable_type, parent_id, rest_ids)
  end
end
