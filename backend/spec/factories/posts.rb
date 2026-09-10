FactoryBot.define do
  factory :post do
    title { "Frustrating day" }
    body { "Today was really hard with my symptoms" }
    # Must be real ciphertext: `Usernameable#user_name` decrypts this to look up the
    # author's screen name, so a placeholder raises once a post is actually serialized.
    encrypted_user_id { FactoryBot.create(:user).encrypted_id }
    symptom_ids { [create(:symptom).id] }
  end
end
