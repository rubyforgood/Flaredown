require 'rails_helper'

RSpec.describe CheckinCreator do
  let!(:user) { create(:user) }
  let!(:condition) { create(:tracking, :for_condition, user: user).trackable }
  let!(:symptom) { create(:tracking, :for_symptom, user: user).trackable }
  let!(:treatment) { create(:tracking, :for_treatment, user: user).trackable }
  let!(:date) { Date.today }

  subject { CheckinCreator.new(user.id, date).create! }

  describe 'create' do
    it 'returns a new checkin prefilled with active trackables' do
      expect(subject.id).to be_present
      expect(subject.user_id).to eq user.id
      expect(subject.date).to eq date
      expect(subject.conditions[0].condition_id).to eq condition.id
      expect(subject.symptoms[0].symptom_id).to eq symptom.id
      expect(subject.treatments[0].treatment_id).to eq treatment.id
    end
    context "when same treatment's doses exist in user's previous checkins" do
      let!(:checkin1) { create(:checkin, user_id: user.id, date: Date.yesterday) }
      let!(:checkin1_treatment) { create(:checkin_treatment, checkin: checkin1, treatment_id: treatment.id, value: '20 mg') }
      let!(:checkin2) { create(:checkin, user_id: user.id, date: Date.today - 2.days) }
      let!(:checkin2_treatment) { create(:checkin_treatment, checkin: checkin2, treatment_id: treatment.id) }
      it 'sets the most recently used dose on the new checkin' do
        checkin_treatment = subject.treatments[0]
        expect(checkin_treatment.treatment_id).to eq treatment.id
        expect(checkin_treatment.value).to eq checkin1_treatment.value
      end
    end
  end
end
