# == Schema Information
#
# Table name: conditions
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  name                   :string
#  trackable_usages_count :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :condition do
    sequence(:name) { |n| "Condition#{n}" }

    trait :personal do
      global { false }
    end
  end
end
