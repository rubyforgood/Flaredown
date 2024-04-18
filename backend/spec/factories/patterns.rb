FactoryBot.define do
  factory :pattern do
    encrypted_user_id { create(:user).encrypted_id }
    start_at { Time.zone.now }
    end_at { 2.days.from_now }
    name { "Chuck Norris" }
  end
end
