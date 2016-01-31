class Checkin::Condition
  include Mongoid::Document

  field :condition_id, type: Integer
  include Checkin::Fiveable

  embedded_in :checkin
end
