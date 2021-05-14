# == Schema Information
#
# Table name: user_treatments
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  treatment_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :user_treatment do
    user
    association :treatment, :personal
  end
end
