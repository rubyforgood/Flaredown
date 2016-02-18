# == Schema Information
#
# Table name: user_conditions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  condition_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :user_condition do
    user
    association :condition, :personal
  end
end
