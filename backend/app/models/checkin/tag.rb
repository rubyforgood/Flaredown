class Checkin::Tag
  include Mongoid::Document

  field :name,       type: String
  has_and_belongs_to_many :checkins

end
