FactoryBot.define do
  factory :topic_following do
    encrypted_user_id { FactoryBot.create(:user).encrypted_id }
  end
end
