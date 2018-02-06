class MergeTrackables::CheckinTrackables
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    if Checkin::FIELD_TYPE.include? trackable_type
      update_health_factors(trackable_type, parent_id, rest_ids)
    else
      update_regular_trackables(trackable_type, parent_id, rest_ids)
    end

    p "PERFORM MergeTrackables::PostTrackables"

    MergeTrackables::PatternIncludes.perform_async(trackable_type, parent_id, rest_ids)
  end

  def update_health_factors(trackable_type, parent_id, rest_ids)
    Checkin.where('tag_ids' => { '$in' => rest_ids }).map do |checkin|
      updated_ids = checkin.send("#{trackable_type}_ids") - rest_ids + [parent_id]

      checkin.update_attributes("#{trackable_type}_ids".to_sym => updated_ids.uniq)
    end
  end

  def update_regular_trackables(trackable_type, parent_id, rest_ids)
    klass = "Checkin::#{trackable_type.capitalize}".constantize
    return unless klass

    klass.where("#{trackable_type}_id".to_sym.in => rest_ids).map do |checkin|
      checkin.update_attributes("#{trackable_type}_id".to_sym => parent_id)
    end
  end
end
