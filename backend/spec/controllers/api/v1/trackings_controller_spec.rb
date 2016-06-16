require 'rails_helper'

RSpec.describe Api::V1::TrackingsController do
  let!(:user) { create(:user) }
  let!(:current_tracking) { create(:tracking, :active, :for_condition, user: user) }
  let!(:old_tracking) { create(:tracking, :inactive, :for_symptom, user: user) }
  let(:another_user_tracking) { create(:tracking, :active, :for_condition) }

  before { sign_in user }

  describe 'index' do
    context 'at current time' do
      let(:trackable_type) { current_tracking.trackable_type }
      let(:at) { Time.now }
      it 'returns current trackings only' do
        get :index, at: at, trackable_type: trackable_type
        returned_ids = response_body[:trackings].map { |t| t[:id] }
        expect(returned_ids).to include current_tracking.id
        expect(returned_ids).not_to include old_tracking.id
      end
    end
    context 'at past time' do
      let(:trackable_type) { old_tracking.trackable_type }
      let(:at) { 5.days.ago }
      it 'returns old trackings only' do
        get :index, at: at, trackable_type: trackable_type
        returned_ids = response_body[:trackings].map { |t| t[:id] }
        expect(returned_ids).to include old_tracking.id
        expect(returned_ids).not_to include current_tracking.id
      end
    end
  end

  describe 'show' do
    context "when a current user's tracking is requested" do
      it 'returns the requested tracking' do
        get :show, id: current_tracking.id
        expect(response_body[:tracking][:id]).to eq current_tracking.id
      end
    end
    context "when another user's tracking is requested" do
      it 'returns 401 (Unauthorized)' do
        get :show, id: another_user_tracking.id
        expect(response.status).to eq 401
      end
    end
  end

  describe 'create' do
    let(:symptom) { create(:symptom) }
    let(:tracking_attributes) { { trackable_id: symptom.id, trackable_type: symptom.class.name } }
    it 'saves a current tracking record' do
      post :create, tracking: tracking_attributes
      expect(response_body[:tracking][:id]).to be_present
      expect(response_body[:tracking][:user_id]).to eq user.id
      expect(response_body[:tracking][:trackable_id]).to eq symptom.id
      expect(response_body[:tracking][:trackable_type]).to eq symptom.class.name
      start_at = Date.parse(response_body[:tracking][:start_at])
      expect(start_at.strftime('%F')).to eq Date.today.strftime('%F')
    end
  end

  describe 'destroy' do
    context "when destroying a current user's tracking" do
      context 'when tracking started in the past' do
        before { current_tracking.update_attributes!(start_at: Date.today - 2.days) }
        it 'sets end_date on that tracking' do
          delete :destroy, id: current_tracking.id
          end_at = current_tracking.reload.end_at
          expect(end_at).to be_present
          expect(end_at.strftime('%F')).to eq Time.now.strftime('%F')
        end
      end
      context 'when tracking started today' do
        it 'destroys that tracking' do
          delete :destroy, id: current_tracking.id
          expect(Tracking.find_by(id: current_tracking.id)).to be_nil
        end
      end
    end
    context "when destroying another user's tracking" do
      it 'returns 401 (Unauthorized)' do
        delete :destroy, id: another_user_tracking.id
        expect(response.status).to eq 401
      end
    end
  end
end
