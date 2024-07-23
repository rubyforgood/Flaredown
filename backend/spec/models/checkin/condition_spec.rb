require "rails_helper"

RSpec.describe Checkin::Condition, type: :model do
  include Mongoid::Matchers

  it_behaves_like 'fiveable'

  describe "Relations" do
    it { is_expected.to belong_to(:checkin) }
  end

  describe "Respond to" do
    it { is_expected.to respond_to(:value) }
  end
end
