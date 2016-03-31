module Flaredown
  class Colorable
    def self.color_id_for(trackable, user)
      parent = Tracking.find_by(trackable: trackable)
      color_id = parent.try(:color_id)
      if color_id.nil?
        used_color_ids = Tracking.where(user_id: user.id).pluck(:color_id)
        colors = (0..32).to_a
        if used_color_ids.count >= colors.count
          color_id = rand(colors.count)
        else
          color_id = (colors - used_color_ids).sample
        end
      end
      color_id
    end
  end
end
