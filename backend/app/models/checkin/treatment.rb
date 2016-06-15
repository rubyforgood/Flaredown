class Checkin::Treatment
  include Mongoid::Document

  #
  # Fields
  #
  field :treatment_id, type: Integer
  field :value, type: String
  field :is_taken, type: Boolean
  field :color_id, type: String

  #
  # Relations
  #
  belongs_to :checkin, index: true

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
