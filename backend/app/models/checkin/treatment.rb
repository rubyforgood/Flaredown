class Checkin::Treatment
  include Mongoid::Document

  field :treatment_id, type: Integer
  field :dose, type: String

  embedded_in :checkin
end
