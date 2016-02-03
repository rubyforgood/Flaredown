class CheckinSerializer < ApplicationSerializer

  attributes :id, :date

  has_many :checkin_conditions, embed: :objects, serializer: ::Checkin::ConditionSerializer
  has_many :checkin_symptoms, embed: :objects, serializer: ::Checkin::SymptomSerializer
  has_many :checkin_treatments, embed: :objects, serializer: ::Checkin::TreatmentSerializer

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
