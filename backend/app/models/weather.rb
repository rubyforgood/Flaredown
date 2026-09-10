# == Schema Information
#
# Table name: weathers
#
#  id               :integer          not null, primary key
#  date             :date
#  humidity         :float
#  icon             :string
#  postal_code      :string
#  precip_intensity :float
#  pressure         :float
#  summary          :string
#  temperature_max  :float
#  temperature_min  :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position_id      :integer
#
# Indexes
#
#  index_weathers_on_date_and_postal_code  (date,postal_code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (position_id => positions.id)
#
class Weather < ActiveRecord::Base
  validates :date, uniqueness: {scope: :position_id}
  # NOTE: if we want to enforce presence, modify spec factory instead
  belongs_to :position, optional: true
end
