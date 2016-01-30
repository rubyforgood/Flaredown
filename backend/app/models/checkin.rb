class Checkin
  include Mongoid::Document

  #
  # Fields
  #
  field :date,       type: Date
  field :user_id,    type: Integer


  #
  # Validations
  #
  validates :user_id, presence: true

  validates :date, presence: true, uniqueness: { scope: :user_id }
end
