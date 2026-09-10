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

class UserSymptom < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :user
  belongs_to :symptom

  #
  # Validations
  #
  validates :user, :symptom, presence: true
end
