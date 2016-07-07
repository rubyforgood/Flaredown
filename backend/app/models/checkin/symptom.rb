class Checkin::Symptom
  include Mongoid::Document
  include Checkin::Trackable
  include Checkin::Fiveable

  field :symptom_id, type: Integer

  validates :symptom_id, uniqueness: { scope: :checkin_id }
end
