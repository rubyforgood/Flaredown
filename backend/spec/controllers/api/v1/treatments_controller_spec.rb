require 'rails_helper'

RSpec.describe Api::V1::TreatmentsController do
  let!(:user) { create(:user) }
  let!(:global_treatment) { create(:treatment) }
  let!(:personal_treatment) { create(:user_treatment, user: user).treatment }
  let!(:another_user_treatment) { create(:user_treatment).treatment }

  let(:user_abilities) { Ability.new(user) }
  let(:accessible_treatments) { Treatment.accessible_by(user_abilities) }

  before { sign_in user }

  describe 'index' do
    it 'returns all accessible treatments' do
      get :index
      returned_treatment_ids = response_body[:treatments].map { |c| c[:id] }
      accessible_treatment_ids = accessible_treatments.map(&:id)
      expect(returned_treatment_ids.to_set).to eq accessible_treatment_ids.to_set
    end
  end

  describe 'show' do
    context 'when treatment is accessible' do
      it 'return the requested treatment' do
        get :show, id: global_treatment.id
        expect(response_body[:treatment][:id]).to eq global_treatment.id
      end
    end
    context 'when local treatment is accessible' do
      it 'returns 200 (Authorized)' do
        get :show, id: another_user_treatment.id
        expect(response.status).to eq 200
      end
    end
  end

  describe 'create' do
    let(:treatment_attributes) { { name: 'Aspirin' } }
    it 'creates the treatment as personal for the current user' do
      post :create, treatment: treatment_attributes
      created_treatment = response_body[:treatment]
      expect(created_treatment[:name]).to eq treatment_attributes[:name]
      expect(Treatment.find(created_treatment[:id]).global).to be false
    end
  end
end
