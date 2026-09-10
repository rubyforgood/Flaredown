# == Schema Information
#
# Table name: user_treatments
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  treatment_id :integer
#  user_id      :integer
#
# Indexes
#
#  index_user_treatments_on_treatment_id  (treatment_id)
#  index_user_treatments_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (treatment_id => treatments.id)
#  fk_rails_...  (user_id => users.id)
#

class UserTreatment < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :user
  belongs_to :treatment

  #
  # Validations
  #
  validates :user, :treatment, presence: true
end
