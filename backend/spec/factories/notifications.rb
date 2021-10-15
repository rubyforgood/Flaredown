FactoryBot.define do
  factory :notification do
    kind { "reaction" }
    notificateable { create(:post) }

    encrypted_user_id { create(:user).encrypted_id }
    encrypted_notify_user_id { create(:user).encrypted_id }

    initialize_with { new(attributes) }
  end
end
