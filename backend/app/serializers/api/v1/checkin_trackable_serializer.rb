module Api
  module V1
    class CheckinTrackableSerializer < ApplicationSerializer
      attributes :checkin_id, :value, :color_id, :position
    end
  end
end
