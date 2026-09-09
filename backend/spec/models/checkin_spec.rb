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

  describe "encrypted_user_id" do
    let(:user) { create(:user) }
    subject(:checkin) { create(:checkin, user_id: user.id) }

    it "persists the user id encrypted rather than in the clear" do
      expect(checkin.encrypted_user_id).to be_present
      expect(checkin.encrypted_user_id).not_to eq user.id.to_s
    end

    it "round-trips back to the Postgres user" do
      expect(checkin.user_id).to eq user.id
      expect(checkin.user).to eq user
    end

    it "is queryable by the encrypted value" do
      checkin
      expect(Checkin.where(encrypted_user_id: user.encrypted_id).to_a).to eq [checkin]
    end
  end
end
