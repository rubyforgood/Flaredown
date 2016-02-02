class Checkin::Treatment
  include Mongoid::Document

  #
  # Fields
  #
  field :treatment_id, type: Integer
  field :dose, type: String

  #
  # Relations
  #
  belongs_to :checkin

  #
  # Indexes
  #
  index(treatment_id: 1)
  index(treatment_id: 1, dose: 1)
end
