require 'rails_helper'

RSpec.describe Checkin, type: :model do
  include Mongoid::Matchers

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_uniqueness_of(:date).scoped_to(:user_id) }
  end

end
