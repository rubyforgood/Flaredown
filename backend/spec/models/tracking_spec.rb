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
#  color_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Tracking, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'ensure_color_id' do
    context 'when have a parent' do
      let(:parent) { create(:tracking, :for_condition) }

      subject { create(:tracking, trackable: parent.trackable) }

      it 'has the same color previous Tracking' do
        expect(subject.color_id).to be_equal(parent.color_id)
      end
    end

    context 'when have a nil color' do
      subject { create(:tracking, :for_condition) }

      it 'has the random color' do
        expect(subject.color_id).to be_present
      end
    end

    context 'when have a color' do
      subject { create(:tracking, :for_condition, color_id: 10) }

      it 'has the assigned color' do
        expect(subject.color_id).to be_equal(10)
      end
    end
  end
end
