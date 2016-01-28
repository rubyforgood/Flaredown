# == Schema Information
#
# Table name: conditions
#
#  id         :integer          not null, primary key
#  global     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :condition do
    sequence(:name) { |n| "Condition#{n}" }

    trait :personal do
      global false
    end
  end
end
