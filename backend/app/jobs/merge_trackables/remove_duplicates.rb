class MergeTrackables::RemoveDuplicates
  include Sidekiq::Worker

  def perform(trackable_type, rest_ids)
    trackable_class = trackable_type.capitalize.constantize
    return unless trackable_class

    trackable_class.where(id: rest_ids).map(&:destroy)
    p "FINISH!!!!"
  end
end
