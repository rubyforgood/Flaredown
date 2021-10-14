FactoryBot.define do
  factory :reaction do
    value { ":smile:" }
    encrypted_user_id { create(:user).encrypted_id }
    reactable { create(:post) }
  end
end
