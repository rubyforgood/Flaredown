class Checkin::Tag
  include Mongoid::Document

  #
  # Fields
  #
  field :name,       type: String
  has_and_belongs_to_many :checkins

end
