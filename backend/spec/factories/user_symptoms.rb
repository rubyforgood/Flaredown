# == Schema Information
#
# Table name: user_symptoms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  symptom_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_user_symptoms_on_symptom_id  (symptom_id)
#  index_user_symptoms_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (symptom_id => symptoms.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :user_symptom do
    user
    association :symptom, :personal
  end
end
