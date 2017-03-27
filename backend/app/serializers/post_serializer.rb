class PostSerializer < ApplicationSerializer
  attributes :id, :body, :title, :tag_ids, :food_ids, :symptom_ids, :condition_ids, :treatment_ids
end
