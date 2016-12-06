class Checkin::Treatment
  include Mongoid::Document
  include Checkin::Trackable

  #
  # Fields
  #
  field :treatment_id, type: Integer
  field :is_taken, type: Boolean

  #
  # Relations
  #
  has_many :takings, class_name: 'Checkin::Taking'
  # TODO: use accepts_nested_attributes_for :takings ?

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
