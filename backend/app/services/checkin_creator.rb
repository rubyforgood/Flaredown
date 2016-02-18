class CheckinCreator
  attr_reader :user, :date

  def initialize(user_id, date)
    @user = User.find(user_id)
    @date = date
  end

  def create!
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
        treatment_attrs << { treatment_id: trackable.id }
      end
    end
    Checkin.create!(
      user_id: user.id, date: date, tag_ids: [],
      conditions_attributes: condition_attrs,
      symptoms_attributes: symptom_attrs,
      treatments_attributes: treatment_attrs
    )
  end
end
