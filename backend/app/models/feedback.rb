class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps

  #
  # Fields
  #
  field :email, type: String
  field :delete_reason, type: String

  #
  # Indexes
  #
  index(date: 1, encrypted_user_id: 1)

  #
  # Validations
  #
  validates :email, :delete_reason, presence: true
end
