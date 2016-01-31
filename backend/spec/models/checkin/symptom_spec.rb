require 'rails_helper'

RSpec.describe Checkin::Symptom, type: :model do
  include Mongoid::Matchers

  describe 'Relations' do
    it { is_expected.to be_embedded_in(:checkin) }
  end

  describe 'Respond to' do
    it { is_expected.to respond_to(:value) }
  end

  describe 'Validations' do
    it { is_expected.to validate_inclusion_of(:value).to_allow(0..4) }
  end

end
