require 'rails_helper'

RSpec.describe Api::V1::ConditionsController do

  let!(:user) { create(:user) }
  let!(:global_condition) { create(:condition) }
  let!(:personal_condition) { create(:user_condition, user: user).condition }
  let!(:another_user_condition) { create(:user_condition).condition }

  let(:user_abilities) { Ability.new(user) }
  let(:accessible_conditions) { Condition.accessible_by(user_abilities) }

  before { sign_in user }

  describe 'index' do
    it 'returns all accessible conditions' do
      get :index
      returned_condition_ids = response_body[:conditions].map { |c| c[:id] }
      accessible_condition_ids = accessible_conditions.map(&:id)
      expect(returned_condition_ids.to_set).to eq accessible_condition_ids.to_set
    end
  end

  describe 'show' do
    context 'when condition is accessible' do
      it 'return the requested condition' do
        get :show, id: global_condition.id
        expect(response_body[:condition][:id]).to eq global_condition.id
      end
    end
    context 'when condition is not accessible' do
      it 'returns 401 (Unauthorized)' do
        get :show, id: another_user_condition.id
        expect(response.status).to eq 401
      end
    end
  end

  describe 'create' do
    let(:condition_attributes) { {name: 'Headache'} }
    it 'creates the condition as personal for the current user' do
      post :create, condition: condition_attributes
      created_condition = response_body[:condition]
      expect(created_condition[:name]).to eq condition_attributes[:name]
      expect(Condition.find(created_condition[:id]).global).to be false
    end
  end

end
