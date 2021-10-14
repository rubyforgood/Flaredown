FactoryBot.define do
  factory :post do
    title { "Frustrating day" }
    body { "Today was really hard with my symptoms" }
    encrypted_user_id { "abcd1234" }
    symptom_ids { [create(:symptom).id] }
  end
end
