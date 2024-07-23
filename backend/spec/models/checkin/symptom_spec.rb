require "rails_helper"

RSpec.describe Checkin::Symptom, type: :model do
  include Mongoid::Matchers

  it_behaves_like 'fiveable'

  describe "Relations" do
    it { is_expected.to belong_to(:checkin) }
  end
end
