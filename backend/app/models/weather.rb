class Weather < ActiveRecord::Base
  validates_uniqueness_of :date, scope: :position_id
  belongs_to :position
end
