FactoryBot.define do
  factory :user_tag do
    user
    association :tag, :personal
  end
end
