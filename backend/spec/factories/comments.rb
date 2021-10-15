FactoryBot.define do
  factory :comment do
    body { "This is a comment." }
    encrypted_user_id { create(:user).encrypted_id }
    post_id { create(:post).id }
  end
end
