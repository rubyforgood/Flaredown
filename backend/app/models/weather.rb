class Weather < ActiveRecord::Base
  validates :date, uniqueness: {scope: :position_id}
  belongs_to :position
end
