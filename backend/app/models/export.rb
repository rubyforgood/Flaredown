class Export
  include Mongoid::Document

  field :user,     type: Hash
  field :profile,  type: Hash
  field :checkins, type: Array

end
