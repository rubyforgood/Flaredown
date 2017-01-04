require 'rails_helper'

describe Weather do
  describe 'Validations' do
    it { is_expected.to validate_uniqueness_of(:date).scoped_to(:postal_code) }
  end
end
