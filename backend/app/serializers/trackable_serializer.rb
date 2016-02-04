module TrackableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :color_id
  end

  def color_id
    @color_id ||= Tracking.find_by(user: current_user, trackable: self.object).try :color_id
  end

end
