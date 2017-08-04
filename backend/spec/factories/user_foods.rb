FactoryGirl.define do
  factory :user_food do
    user
    association :food, :personal
  end
end
