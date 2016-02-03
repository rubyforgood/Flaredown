# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  start_at       :date
#  end_at         :date
#

require 'rails_helper'

RSpec.describe Tracking, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end
end
