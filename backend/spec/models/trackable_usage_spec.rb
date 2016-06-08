# == Schema Information
#
# Table name: trackable_usages
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  count          :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

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
