class Checkin::Treatment
  include Mongoid::Document
  include Checkin::Trackable

  #
  # Fields
  #
  field :treatment_id, type: Integer
  field :value, type: String
  field :is_taken, type: Boolean

  #
  # Indexes
  #
  index(treatment_id: 1)
  index(treatment_id: 1, is_taken: 1, value: 1)

  #
  # Validations
  #
  validates :treatment_id, uniqueness: { scope: :checkin_id }

end
