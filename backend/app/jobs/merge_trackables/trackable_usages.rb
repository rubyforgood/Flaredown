class MergeTrackables::TrackableUsages
  include Sidekiq::Worker

  def perform(trackable_type, parent_id, rest_ids)
    trackable_class = trackable_type.capitalize.constantize
    return unless trackable_class

    parent = trackable_class.find_by(id: parent_id)
    rest = trackable_class.where(id: rest_ids)
    return if parent.nil? && rest.length.zero?

    TrackableUsage.where(trackable: rest).map do |tr_usage|
      parent_usage = TrackableUsage.find_by(trackable: parent, user_id: tr_usage.user_id)

      if parent_usage
        parent_usage.count += tr_usage.count
        parent_usage.save

        tr_usage.destroy
      else
        # `belongs_to :trackable, counter_cache: true` already moves the count from the
        # duplicate to the parent when the foreign key changes; incrementing here as well
        # counted every merged usage twice.
        tr_usage.update(trackable_id: parent.id)
      end
    end

    p "PERFORM MergeTrackables::Trackings"

    MergeTrackables::Trackings.perform_async(trackable_type, parent_id, rest_ids)
  end
end
