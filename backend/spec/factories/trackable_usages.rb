FactoryGirl.define do
  factory :trackable_usage do
    user
    association :trackable, factory: :condition
  end

end
