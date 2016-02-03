class CheckinSerializer < ApplicationSerializer

  attributes :id, :date

  has_many :checkin_conditions, embed: :objects, serializer: CheckinConditionSerializer
  has_many :checkin_symptoms, embed: :objects, serializer: CheckinSymptomSerializer
  has_many :checkin_treatments, embed: :objects, serializer: CheckinTreatmentSerializer

  def checkin_conditions
    object.conditions
  end

  def checkin_symptoms
    object.symptoms
  end

  def checkin_treatments
    object.treatments
  end

end
