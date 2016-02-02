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
      expect(subject.user_id).to eq user.id
      expect(subject.date).to eq date
      expect(subject.conditions[0].condition_id).to eq condition.id
      expect(subject.symptoms[0].symptom_id).to eq symptom.id
      expect(subject.treatments[0].treatment_id).to eq treatment.id
    end
  end

end
