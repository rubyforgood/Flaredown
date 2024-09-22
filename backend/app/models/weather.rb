class Weather < ActiveRecord::Base
  validates :date, uniqueness: {scope: :position_id}
  # NOTE: if we want to enforce presence, modify spec factory instead
  belongs_to :position, optional: true
end
