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
  belongs_to :checkin

  #
  # Indexes
  #
  index(treatment_id: 1)
  index(treatment_id: 1, value: 1)
end
