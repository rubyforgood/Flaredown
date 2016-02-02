require 'rails_helper'

RSpec.describe Checkin::Treatment, type: :model do
  include Mongoid::Matchers

  describe 'Relations' do
    it { is_expected.to belong_to(:checkin) }
  end

  describe 'Respond to' do
    it { is_expected.to respond_to(:dose) }
  end

end
