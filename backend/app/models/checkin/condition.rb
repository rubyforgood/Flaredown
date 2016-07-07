class Checkin::Condition
  include Mongoid::Document
  include Checkin::Trackable
  include Checkin::Fiveable

  field :condition_id, type: Integer

  validates :condition_id, uniqueness: { scope: :checkin_id }
end
