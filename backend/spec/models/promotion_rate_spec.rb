require 'rails_helper'

describe PromotionRate do
  include Mongoid::Matchers

  describe 'Relations' do
    it { is_expected.to belong_to(:checkin) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:checkin) }
    it { is_expected.to validate_uniqueness_of(:checkin_id) }
  end
end
