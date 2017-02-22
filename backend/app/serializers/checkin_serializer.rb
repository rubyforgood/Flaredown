class CheckinSerializer < ApplicationSerializer
  attributes :id, :date, :note, :tag_ids, :food_ids, :postal_code, :available_for_hbi?

  has_many :conditions, embed: :objects, serializer: CheckinConditionSerializer
  has_many :symptoms, embed: :objects, serializer: CheckinSymptomSerializer
  has_many :treatments, embed: :objects, serializer: CheckinTreatmentSerializer

  has_one :weather, embed_in_root: true
  has_many :tags, embed_in_root: true
  has_many :foods, embed_in_root: true

  has_one :harvey_bradshaw_index
end
