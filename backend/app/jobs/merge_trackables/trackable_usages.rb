class MergeTrackables::TrackableUsages
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    trackable_class = trackable_type.capitalize.constantize
    return unless trackable_class

    parent = trackable_class.find_by(id: parent_id)
    rest = trackable_class.where(id: rest_ids)
    return if parent.nil? && rest.length.zero?

    TrackableUsage.where(trackable: rest).map do |tr_usage|
      begin
        tr_usage.update_attributes(trackable_id: parent.id)

      rescue ActiveRecord::RecordNotUnique
        parent_usage = TrackableUsage.find_by(trackable_type: tr_usage.trackable_type,
                                              trackable_id: parent_id,
                                              user_id: tr_usage.user_id)
        next unless parent_usage

        parent_usage.count += tr_usage.count
        parent_usage.save

        tr_usage.destroy
      end

      parent.increment!(:trackable_usages_count)
    end

    p "PERFORM MergeTrackables::Trackings"

    MergeTrackables::Trackings.perform_async(trackable_type, parent_id, rest_ids)
  end
end
