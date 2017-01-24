module Flaredown
  class Colorable

    def self.color_id_for(trackable, user)
      parent = Tracking.find_by(user: user, trackable: trackable)
      color_id = parent.try(:color_id)
      if color_id.blank? && user.present?
        used_color_ids = Tracking.where(user_id: user.id).pluck(:color_id)
        colors = (0..32).to_a
        color_id =
          if used_color_ids.count >= colors.count
            used_color_ids.count % colors.count
          else
            (colors - used_color_ids).sample
          end
      end
      color_id
    end

  end
end
