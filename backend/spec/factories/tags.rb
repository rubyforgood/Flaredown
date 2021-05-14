# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }

    trait :personal do
      global { false }
    end
  end
end
