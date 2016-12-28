require 'rails_helper'

RSpec.describe Food do
  describe 'Respond to' do
    it { is_expected.to respond_to(:long_desc) }
    it { is_expected.to respond_to(:shrt_desc) }
    it { is_expected.to respond_to(:comname) }
    it { is_expected.to respond_to(:sciname) }
  end
end
