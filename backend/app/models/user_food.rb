class UserFood < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :user
  belongs_to :food

  #
  # Validations
  #
  validates :user, :food, presence: true
end
