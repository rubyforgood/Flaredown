class CheckinCreator
  attr_reader :user, :date

  def initialize(user_id, date)
    @user = User.find(user_id)
    @date = date
  end

  def create!
    checkin = Checkin.new(user_id: user.id, date: date, tag_ids: [])
    active_trackables = user.trackings.active_at(date).map(&:trackable)
    condition_attrs = []
    symptom_attrs = []
    treatment_attrs = []
    active_trackables.each do |trackable|
      if trackable.is_a? Condition
        condition_attrs << { condition_id: trackable.id }
      elsif trackable.is_a? Symptom
        symptom_attrs << { symptom_id: trackable.id }
      elsif trackable.is_a? Treatment
        treatment_attrs << {
          treatment_id: trackable.id,
          value: checkin.most_recent_value_for('Checkin::Treatment', trackable.id)
        }
      end
    end
    checkin.update_attributes!(
      conditions_attributes: condition_attrs,
      symptoms_attributes: symptom_attrs,
      treatments_attributes: treatment_attrs
    )
    checkin
  end

end
