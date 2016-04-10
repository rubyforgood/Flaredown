require 'rails_helper'

RSpec.describe Checkin::Creator do
  let!(:user) { create(:user) }
  let!(:condition) { create(:tracking, :for_condition, user: user).trackable }
  let!(:symptom) { create(:tracking, :for_symptom, user: user).trackable }
  let!(:treatment) { create(:tracking, :for_treatment, user: user).trackable }
  let!(:date) { Date.today }

  subject { Checkin::Creator.new(user.id, date).create! }

  describe 'create' do
    it 'returns a new checkin prefilled with active trackables' do
      expect(subject.id).to be_present
      expect(subject.user_id).to eq user.id
      expect(subject.date).to eq date
      expect(subject.conditions[0].condition_id).to eq condition.id
      expect(subject.symptoms[0].symptom_id).to eq symptom.id
      expect(subject.treatments[0].treatment_id).to eq treatment.id
    end
    context "when recent dose exists for treatment in user's profile" do
      before do
        user.profile.set_most_recent_dose(treatment.id, '20 mg')
        user.profile.save!
      end
      it 'sets dose from profile on the new checkin' do
        checkin_treatment = subject.treatments[0]
        expect(checkin_treatment.treatment_id).to eq treatment.id
        saved_dose = user.profile.most_recent_dose_for(treatment.id)
        expect(checkin_treatment.value).to eq saved_dose
      end
    end
  end
end
