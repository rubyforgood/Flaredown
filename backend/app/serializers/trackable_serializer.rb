module TrackableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :color_id, :type
  end

  def color_id
    @color_id ||= Tracking.find_by(user: current_user, trackable: object).try :color_id
  end

  def type
    object.class.name.downcase.dasherize
  end
end
