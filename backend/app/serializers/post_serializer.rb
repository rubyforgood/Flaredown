class PostSerializer < ApplicationSerializer
  attributes :id, :body, :title, :tag_ids, :food_ids, :symptom_ids,
             :condition_ids, :treatment_ids, :user_name, :comments_count

  has_many :tags, embed_in_root: true
  has_many :foods, embed_in_root: true
  has_many :comments, embed_in_root: true
  has_many :symptoms, embed_in_root: true
  has_many :conditions, embed_in_root: true
  has_many :treatments, embed_in_root: true
end
