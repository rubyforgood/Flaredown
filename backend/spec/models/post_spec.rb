require 'rails_helper'

describe Post do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:encrypted_user_id) }
  end
end
