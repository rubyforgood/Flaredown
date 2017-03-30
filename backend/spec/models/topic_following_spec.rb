require 'rails_helper'

describe TopicFollowing do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:encrypted_user_id) }
  end
end
