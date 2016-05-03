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
#  color_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :tracking do
    user

    trait :for_condition do
      association :trackable, factory: :condition
    end

    trait :for_symptom do
      association :trackable, factory: :symptom
    end

    trait :for_treatment do
      association :trackable, factory: :treatment
    end

    trait :active do
      start_at { Date.today }
    end

    trait :inactive do
      start_at { Date.today - 7.days }
      end_at { Date.yesterday }
    end
  end
end
