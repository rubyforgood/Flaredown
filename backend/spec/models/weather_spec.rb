require "rails_helper"

describe Weather do
  describe "Validations" do
    it { is_expected.to validate_uniqueness_of(:date).scoped_to(:position_id) }
  end
end
