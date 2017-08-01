class UserTag < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :user
  belongs_to :tag

  #
  # Validations
  #
  validates :user, :tag, presence: true
end
