class MergeTrackables::CheckinTrackables
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    klass = "Checkin::#{trackable_type.capitalize}".constantize
    return unless klass

    klass.where("#{trackable_type}_id".to_sym.in => rest_ids).map do |checkin|
      checkin.update_attributes("#{trackable_type}_id".to_sym => parent_id)
    end

    p "PERFORM MergeTrackables::PostTrackables"

    MergeTrackables::PostTrackables.perform_async(trackable_type, parent_id, rest_ids)
  end
end
