require 'rails_helper'

RSpec.describe Api::V1::SymptomsController do
  let!(:user) { create(:user) }
  let!(:global_symptom) { create(:symptom) }
  let!(:personal_symptom) { create(:user_symptom, user: user).symptom }
  let!(:another_user_symptom) { create(:user_symptom).symptom }

  let(:user_abilities) { Ability.new(user) }
  let(:accessible_symptoms) { Symptom.accessible_by(user_abilities) }

  before { sign_in user }

  describe 'index' do
    it 'returns all accessible symptoms' do
      get :index
      returned_symptom_ids = response_body[:symptoms].map { |c| c[:id] }
      accessible_symptom_ids = accessible_symptoms.map(&:id)
      expect(returned_symptom_ids.to_set).to eq accessible_symptom_ids.to_set
    end
  end

  describe 'show' do
    context 'when symptom is accessible' do
      it 'return the requested symptom' do
        get :show, id: global_symptom.id
        expect(response_body[:symptom][:id]).to eq global_symptom.id
      end
    end
    context 'when symptom is not accessible' do
      it 'returns 401 (Unauthorized)' do
        get :show, id: another_user_symptom.id
        expect(response.status).to eq 401
      end
    end
  end

  describe 'create' do
    let(:symptom_attributes) { { name: 'Headache' } }
    it 'creates the symptom as personal for the current user' do
      post :create, symptom: symptom_attributes
      created_symptom = response_body[:symptom]
      expect(created_symptom[:name]).to eq symptom_attributes[:name]
      expect(Symptom.find(created_symptom[:id]).global).to be false
    end
  end
end
