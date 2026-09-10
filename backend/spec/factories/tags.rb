# == Schema Information
#
# Table name: tags
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  name                   :string
#  trackable_usages_count :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }

    trait :personal do
      global { false }
    end
  end
end
