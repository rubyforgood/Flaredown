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
