class Checkin::Symptom
  include Mongoid::Document

  field :symptom_id, type: Integer
  field :color_id, type: String
  include Checkin::Fiveable

  belongs_to :checkin, index: true
end
