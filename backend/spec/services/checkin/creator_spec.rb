require 'rails_helper'

RSpec.describe Checkin::Creator do
  let!(:user) { create(:user) }
  let!(:condition_tracking) { create(:tracking, :active, :for_condition, user: user) }
  let!(:condition) { condition_tracking.trackable }
  let!(:symptom_tracking) { create(:tracking, :active, :for_symptom, user: user) }
  let!(:symptom) { symptom_tracking.trackable }
  let!(:treatment_tracking) { create(:tracking, :active, :for_treatment, user: user) }
  let!(:treatment) { treatment_tracking.trackable }
  let!(:date) { Time.zone.today }

  subject { Checkin::Creator.new(user.id, date).create! }

  describe 'create' do

    it 'returns a new checkin prefilled with active trackables' do
      expect(subject.id).to be_present
      expect(subject.user_id).to eq user.id
      expect(subject.date).to eq date
      # Condition
      checkin_condition = subject.conditions[0]
      expect(checkin_condition.condition_id).to eq condition.id
      expect(checkin_condition.color_id).to eq condition_tracking.color_id.to_s
      expect(checkin_condition.position).to eq 0
      # Symptom
      checkin_symptom = subject.symptoms[0]
      expect(checkin_symptom.symptom_id).to eq symptom.id
      expect(checkin_symptom.color_id).to eq symptom_tracking.color_id.to_s
      expect(checkin_symptom.position).to eq 0
      # Treatment
      checkin_treatment = subject.treatments[0]
      expect(checkin_treatment.treatment_id).to eq treatment.id
      expect(checkin_treatment.color_id).to eq treatment_tracking.color_id.to_s
      expect(checkin_treatment.position).to eq 0
      expect(checkin_treatment.is_taken).to be false
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

    context "when recent position exists for a trackable in user's profile" do
      before do
        user.profile.set_most_recent_trackable_position(condition, 5)
        user.profile.save!
      end
      it 'sets trackable position from profile on the new checkin' do
        checkin_condition = subject.conditions[0]
        expect(checkin_condition.condition_id).to eq condition.id
        saved_position = user.profile.most_recent_trackable_position_for(condition)
        expect(checkin_condition.position).to eq saved_position
      end
    end

    context "when no recent position exists for a trackable in user's profile" do
      before { create(:tracking, :active, :for_condition, user: user) }
      it "sets positions with auto-increment counter starting by 1" do
        positions = subject.conditions.map(&:position)
        expect(positions.to_set).to eq [0, 1].to_set
      end
    end

    context "when trackables never used before" do
      it "creates new usage records" do
        # For Condition
        expect(subject.conditions).to be_present
        condition_usage = TrackableUsage.find_by(user: user, trackable: condition)
        expect(condition_usage).to be_present
        expect(condition_usage.count).to eq 1
        # For Symptom
        expect(subject.symptoms).to be_present
        symptom_usage = TrackableUsage.find_by(user: user, trackable: symptom)
        expect(symptom_usage).to be_present
        expect(symptom_usage.count).to eq 1
        # For Treatment
        expect(subject.treatments).to be_present
        treatment_usage = TrackableUsage.find_by(user: user, trackable: treatment)
        expect(treatment_usage).to be_present
        expect(treatment_usage.count).to eq 1
      end
    end

    context "when trackables already used before" do
      let!(:condition_usage) { TrackableUsage.create!(user: user, trackable: condition) }
      let!(:condition_usage_count) { condition_usage.count }
      let!(:symptom_usage) { TrackableUsage.create!(user: user, trackable: symptom) }
      let!(:symptom_usage_count) { symptom_usage.count }
      let!(:treatment_usage) { TrackableUsage.create!(user: user, trackable: treatment) }
      let!(:treatment_usage_count) { treatment_usage.count }
      it "increments count on usage records" do
        # For Condition
        expect(subject.conditions).to be_present
        expect(condition_usage.reload.count).to eq(condition_usage_count + 1)
        # For Symptom
        expect(subject.symptoms).to be_present
        expect(symptom_usage.reload.count).to eq(symptom_usage_count + 1)
        # For Treatment
        expect(subject.treatments).to be_present
        expect(treatment_usage.reload.count).to eq(treatment_usage_count + 1)
      end
    end

    context 'when postal code is set on previous checkin' do
      let(:weather) { create :weather }
      let(:postal_code) { '55403' }
      let(:position) { Position.create(postal_code: postal_code) }

      let!(:previous_checkin) { create :checkin, user_id: user.id, position_id: position.id }

      before { expect(WeatherRetriever).to receive(:get).and_return(weather) }

      it 'should ask for weather' do
        expect(subject.position.postal_code).to eq(postal_code)
        expect(subject.weather_id).to eq(weather.id)
      end
    end
  end
end
