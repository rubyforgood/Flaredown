FactoryBot.define do
  factory :promotion_rate do
    user_id { FactoryBot.create(:user).id }
    sequence(:date) { |n| Time.zone.now - n.days }
    score { rand(1..10) }
  end
end
