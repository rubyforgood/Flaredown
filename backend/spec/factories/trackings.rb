# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  start_at       :date
#  end_at         :date
#

FactoryGirl.define do
  factory :tracking do
    user
    start_at Date.today

    trait :for_condition do
      association :trackable, factory: :condition
    end

    trait :for_symptom do
      association :trackable, factory: :symptom
    end

    trait :for_treatment do
      association :trackable, factory: :treatment
    end
  end
end
