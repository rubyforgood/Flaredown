class Checkin::Condition
  include Mongoid::Document

  field :condition_id, type: Integer
  field :color_id, type: String
  include Checkin::Fiveable

  belongs_to :checkin, index: true
end
