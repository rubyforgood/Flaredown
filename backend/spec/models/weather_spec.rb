require "rails_helper"

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
describe Weather do
  describe "Validations" do
    it { is_expected.to validate_uniqueness_of(:date).scoped_to(:position_id) }
  end
end
