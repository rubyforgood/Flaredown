class Post
  include Mongoid::Document

  field :body,  type: String
  field :title, type: String

  field :tag_ids,       type: Array
  field :food_ids,      type: Array
  field :symptom_ids,   type: Array
  field :condition_ids, type: Array
  field :treatment_ids, type: Array

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :body, :title, :encrypted_user_id, presence: true
end
