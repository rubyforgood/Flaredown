module TopicSerializable
  extend ActiveSupport::Concern

  included do
    attributes :id, :tag_ids, :food_ids, :symptom_ids, :condition_ids, :treatment_ids

    has_many :tags, embed_in_root: true
    has_many :foods, embed_in_root: true
    has_many :symptoms, embed_in_root: true
    has_many :conditions, embed_in_root: true
    has_many :treatments, embed_in_root: true
  end
end
