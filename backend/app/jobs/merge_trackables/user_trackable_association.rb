class MergeTrackables::UserTrackableAssociation
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    trackable_class = trackable_type.capitalize.constantize
    klass = "User#{trackable_type.capitalize}".constantize
    return unless trackable_class && klass

    parent = trackable_class.find_by(id: parent_id)
    rest = trackable_class.where(id: rest_ids)
    return if parent.nil? && rest.length.zero?

    klass.where(trackable_type.to_sym => rest).map do |user_trackable_type|
      parent_user_trackable = klass.find_by(trackable_type.to_sym => parent,
                                            user_id: user_trackable_type.user_id)

      if parent_user_trackable.present?
        user_trackable_type.destroy
      else
        user_trackable_type.update_columns("#{trackable_type}_id".to_sym => parent.id)
      end
    end

    p "PERFORM MergeTrackables::TrackableUsages"
    MergeTrackables::TrackableUsages.perform_async(trackable_type, parent_id, rest_ids)
  end
end
