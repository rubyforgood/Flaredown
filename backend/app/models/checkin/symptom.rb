class Checkin::Symptom
  include Mongoid::Document

  field :symptom_id, type: Integer
  include Checkin::Fiveable

  embedded_in :checkin
end
