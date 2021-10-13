class Checkin::Creator
  attr_reader :user, :date

  def initialize(user_id, date)
    @user = User.find(user_id)
    @date = date
  end

  # FIXME
  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/AbcSize
  def create!
    prev_checkin = user.last_checkin
    checkin = Checkin.new(user_id: user.id, date: date, tag_ids: [], food_ids: [])

    if prev_checkin && prev_checkin.position.present?
      checkin.position_id = prev_checkin.position_id
      checkin.weather_id = WeatherRetriever.get(date, checkin.position.postal_code)&.id
    end

    active_trackings = user.trackings.includes(:trackable).active_at(date)
    condition_attrs = []
    symptom_attrs = []
    treatment_attrs = []
    active_trackings.each do |tracking|
      trackable = tracking.trackable
      most_recent_position = user.profile.most_recent_trackable_position_for(trackable)
      if trackable.is_a? Condition
        condition_attrs << {
          condition_id: trackable.id,
          position: most_recent_position || condition_attrs.length,
          color_id: tracking.color_id
        }
      elsif trackable.is_a? Symptom
        symptom_attrs << {
          symptom_id: trackable.id,
          position: most_recent_position || symptom_attrs.length,
          color_id: tracking.color_id
        }
      elsif trackable.is_a? Treatment
        treatment_attrs << {
          treatment_id: trackable.id,
          position: most_recent_position || treatment_attrs.length,
          color_id: tracking.color_id,
          is_taken: false,
          value: user.profile.most_recent_dose_for(trackable.id)
        }
      end
    end
    checkin.update!(
      conditions_attributes: condition_attrs,
      symptoms_attributes: symptom_attrs,
      treatments_attributes: treatment_attrs
    )
    create_or_update_trackable_usages(checkin)
    checkin
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/AbcSize

  private

  def create_or_update_trackable_usages(checkin)
    %w[Condition Symptom Treatment].each do |trackable_class_name|
      trackable_class = trackable_class_name.constantize
      trackable_id_method = "#{trackable_class_name.downcase}_id"
      checkin_trackables_method = trackable_class_name.downcase.pluralize
      checkin.send(checkin_trackables_method).each do |checkin_trackable|
        trackable_id = checkin_trackable.send(trackable_id_method)
        TrackableUsage.create_or_update_by(
          user: user,
          trackable: trackable_class.find(trackable_id)
        )
      end
    end
  end
end
