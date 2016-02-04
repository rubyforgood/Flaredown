module Flaredown
  class Colorable

    def self.color_id_for(trackable)
      parent = Tracking.find_by(trackable: trackable)
      parent.try(:color_id) || rand(32)
    end

  end

end

