# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  end_at         :date
#  start_at       :date
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  color_id       :integer
#  trackable_id   :integer
#  user_id        :integer
#
# Indexes
#
#  index_trackings_on_trackable_type                   (trackable_type)
#  index_trackings_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_trackings_on_user_id                          (user_id)
#  index_trackings_unique_trackable                    (user_id,trackable_id,trackable_type,start_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
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
      start_at { Time.zone.today }
    end

    trait :inactive do
      start_at { Time.zone.today - 7.days }
      end_at { Date.yesterday }
    end
  end
end
