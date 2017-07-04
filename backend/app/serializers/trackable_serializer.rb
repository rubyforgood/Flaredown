module TrackableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :color_id, :type, :users_count, :active_link
  end

  def color_id
    @color_id ||= Tracking.find_by(user: current_user, trackable: object).try :color_id
  end

  def type
    object.class.name.downcase.dasherize
  end

  def users_count
    TopicFollowing.where("#{type}_ids": object.id).count
  end

  def active_link
    Ability.new(current_user).can?(:read, object)
  end
end
