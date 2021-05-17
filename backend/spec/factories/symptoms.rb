# == Schema Information
#
# Table name: symptoms
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  trackable_usages_count :integer          default(0)
#

FactoryBot.define do
  factory :symptom do
    sequence(:name) { |n| "Symptom#{n}" }

    trait :personal do
      global { false }
    end
  end
end
