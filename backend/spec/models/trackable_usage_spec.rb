require 'rails_helper'

RSpec.describe TrackableUsage, type: :model do

  describe 'Respond to' do
    it { is_expected.to respond_to(:count) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:trackable) }
  end

  describe 'Validations' do
    it { is_expected.to validate_numericality_of(:count).is_greater_than(0) }
  end

end
