require 'rails_helper'

describe Position do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:postal_code) }
  end
end
