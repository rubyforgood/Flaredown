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

class UserCondition < ActiveRecord::Base

  #
  # Associations
  #
  belongs_to :user
  belongs_to :condition

  #
  # Validations
  #
  validates :user, :condition, presence: true

end
