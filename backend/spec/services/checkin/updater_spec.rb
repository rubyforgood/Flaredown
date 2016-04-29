require 'rails_helper'

RSpec.describe Checkin::Updater do
  let(:user) { create(:user) }
  let(:checkin) { create(:checkin, user_id: user.id, date: Date.today) }

  subject { Checkin::Updater.new(user, params).update! }

  context 'with permitted params' do
    let(:params) { ActionController::Parameters.new(id: checkin.id.to_s, checkin: { note: 'Blah' } ) }
    it 'returns updated checkin' do
      expect(subject.id).to eq checkin.id
      expect(subject.note).to eq params[:checkin][:note]
    end
  end

  context 'with non-permitted params' do
    let(:params) { ActionController::Parameters.new(id: checkin.id.to_s, checkin: { date: Date.yesterday } ) }
    it 'returns checkin with no changes' do
      expect(subject.id).to eq checkin.id
      expect(subject.date).not_to eq params[:checkin][:date]
    end
  end

  context "when recent dose exists for treatment in user's profile" do
    let(:treatment) { create(:treatment) }
    let(:params) { ActionController::Parameters.new(id: checkin.id.to_s, checkin: { treatments_attributes: [{ treatment_id: treatment.id }] } ) }
    before do
      user.profile.set_most_recent_dose(treatment.id, '20 mg')
      user.profile.save!
    end
    it 'auto-sets the most recently used dose on added treatments' do
      returned_treatment = subject.treatments[0]
      expect(returned_treatment.treatment_id).to eq treatment.id
      saved_dose = user.profile.most_recent_dose_for(treatment.id)
      expect(returned_treatment.value).to eq saved_dose
    end
  end

  context "trackable usages" do

    context "when removing a trackable" do
      let!(:checkin_condition) { create(:checkin_condition, checkin: checkin) }
      let!(:condition) { Condition.find(checkin_condition.condition_id) }
      let!(:usage) { create(:trackable_usage, user: user, trackable: condition) }
      let(:params) do
        ActionController::Parameters.new(
          id: checkin.id.to_s,
          checkin: {
            conditions_attributes: [{
              id: checkin_condition.id.to_s,
              condition_id: checkin_condition.condition_id,
              _destroy: '1'
            }]
          }
        )
      end
      context "used once before" do
        it "removes trackable and usage record" do
          expect(subject.conditions.map(&:id)).not_to include checkin_condition.id
          expect(TrackableUsage.find_by(user: user, trackable: condition)).to be_nil
        end
      end
      context "used more than once before" do
        let!(:previous_count) { usage.count }
        before { usage.increment! :count }
        it "removes trackable and decrements count on usage record" do
          expect(subject.conditions.map(&:id)).not_to include checkin_condition.id
          expect(usage.count).to eq previous_count+1
        end
      end
    end

    context "when adding a trackable" do
      let!(:condition) { create(:condition) }
      let(:params) do
        ActionController::Parameters.new(
          id: checkin.id.to_s,
          checkin: {
            conditions_attributes: [{
              condition_id: condition.id,
            }]
          }
        )
      end
      context "never used before" do
        it "adds trackable and creates a new usage record" do
          expect(subject.conditions.map(&:condition_id)).to include condition.id
          expect(TrackableUsage.find_by(user: user, trackable: condition)).to be_present
        end
      end
      context "already used before" do
        let!(:usage) { TrackableUsage.find_or_create_by(user: user, trackable: condition) }
        let!(:previous_count) { usage.count }
        it "adds trackable and increments count on usage record" do
          expect(subject.conditions.map(&:condition_id)).to include condition.id
          expect(usage.reload.count).to eq previous_count+1
        end
      end
    end

  end

end
