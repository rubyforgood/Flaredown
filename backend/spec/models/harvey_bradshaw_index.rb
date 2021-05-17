require "rails_helper"

describe HarveyBradshawIndex do
  include Mongoid::Matchers

  describe "Relations" do
    it { is_expected.to belong_to(:checkin) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:checkin) }

    it { is_expected.to validate_presence_of(:stools) }
    it { is_expected.to validate_presence_of(:well_being) }
    it { is_expected.to validate_presence_of(:abdominal_mass) }
    it { is_expected.to validate_presence_of(:abdominal_pain) }

    it { is_expected.to validate_uniqueness_of(:checkin_id) }
  end
end
