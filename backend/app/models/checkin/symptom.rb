class Checkin::Symptom
  include Mongoid::Document
  include Checkin::Trackable

  field :symptom_id, type: Integer

  has_many :ratings, class_name: 'Checkin::Rating', as: :trackable
  # TODO: use accepts_nested_attributes_for :ratings ?

  validates :symptom_id, uniqueness: { scope: :checkin_id }
end
