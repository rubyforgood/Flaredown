class Checkin::Symptom
  include Mongoid::Document

  field :symptom_id, type: Integer
  include Checkin::Fiveable

  belongs_to :checkin
end
