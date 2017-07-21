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

  describe 'Callbacks' do
    before(:all) do
      @condition = create(:condition, :personal)
      create_list(:trackable_usage,
                  Flaredown.config.trackables_min_popularity - 1,
                  trackable_type: @condition.class.to_s,
                  trackable_id: @condition.id)
    end

    subject { TrackableUsage.last }

    context "for small amount of tracks doesn't switch topic to global" do
      before(:each) { subject.run_callbacks(:commit) }

      it { expect(subject.trackable.reload.global?).to be false }
    end
  end
end
