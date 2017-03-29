class TopicFollowing
  include Mongoid::Document

  field :tag_ids,       type: Array, default: []
  field :food_ids,      type: Array, default: []
  field :symptom_ids,   type: Array, default: []
  field :condition_ids, type: Array, default: []
  field :treatment_ids, type: Array, default: []

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :encrypted_user_id, presence: true
end
