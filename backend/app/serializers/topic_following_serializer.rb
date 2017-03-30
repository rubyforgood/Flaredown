class TopicFollowingSerializer < ApplicationSerializer
  attributes :id, :tag_ids, :food_ids, :symptom_ids, :condition_ids, :treatment_ids
end
