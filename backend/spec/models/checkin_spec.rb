require "rails_helper"

RSpec.describe Checkin, type: :model do
  include Mongoid::Matchers

  describe "Relations" do
    it { is_expected.to have_many(:conditions) }
    it { is_expected.to have_many(:symptoms) }
    it { is_expected.to have_many(:treatments) }
    it { is_expected.to have_one(:harvey_bradshaw_index) }
    it { is_expected.to have_one(:promotion_rate) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:encrypted_user_id) }
  end
end
