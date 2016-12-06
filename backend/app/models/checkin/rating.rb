class Checkin::Rating
  include Mongoid::Document
  include Checkin::Timeable
  include Checkin::Fiveable

  belongs_to :trackable, polymorphic: true
end
