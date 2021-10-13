class SwitchTrackableVisibility < ApplicationJob
  queue_as :default

  def perform(trackable_usage_id)
    trackable_usage = TrackableUsage.find_by(id: trackable_usage_id)
    return unless trackable_usage

    trackable = trackable_usage.trackable.reload

    if trackable.trackable_usages_count >= Flaredown.config.trackables_min_popularity
      trackable.update(global: true)
    else
      trackable.update(global: false) if trackable.global? # rubocop:disable Style/IfInsideElse
    end
  end
end
