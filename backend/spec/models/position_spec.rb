require "rails_helper"

# == Schema Information
#
# Table name: positions
#
#  id            :integer          not null, primary key
#  latitude      :decimal(10, 7)
#  location_name :string           not null
#  longitude     :decimal(10, 7)
#  postal_code   :string           not null
#
describe Position do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:postal_code) }
  end
end
