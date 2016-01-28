# == Schema Information
#
# Table name: user_symptoms
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  symptom_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user_symptom do
    user
    association :symptom, :personal
  end

end
