class CheckinSerializer < ApplicationSerializer

  attributes :id, :date

  has_many :conditions, embed: :objects, serializer: CheckinConditionSerializer
  has_many :symptoms, embed: :objects, serializer: CheckinSymptomSerializer
  has_many :treatments, embed: :objects, serializer: CheckinTreatmentSerializer

end
