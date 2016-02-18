require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'show' do
    context 'when no user logged-in' do
      it 'returns 401 (unauthorized)' do
        get :show, id: user.id
        expect(response.status).to eq 401
      end
    end

    context 'when different user logged-in' do
      before { sign_in another_user }
      it 'returns 401 (unauthorized)' do
        get :show, id: user.id
        expect(response.status).to eq 401
      end
    end

    context 'when user logged-in' do
      before { sign_in user }
      it 'returns user' do
        get :show, id: user.id
        expect(response_body[:user][:id]).to eq user.id
      end

      context 'with invalid user id' do
        it 'returns 404 (RecordNotFound)' do
          get :show, id: 'a123'
          expect(response.status).to eq 404
        end
      end

      context 'when different user id is requested' do
        it 'returns 401 (unauthorized)' do
          get :show, id: another_user.id
          expect(response.status).to eq 401
        end
      end
    end
  end
end
