# == Schema Information
#
# Table name: user_conditions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  condition_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe UserCondition do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:condition) }
  end
end
