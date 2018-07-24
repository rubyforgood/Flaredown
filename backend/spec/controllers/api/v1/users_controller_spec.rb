require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'show' do
    context 'when no user logged-in' do
      it 'returns 302 (Permanent Redirect)' do
        get :show, id: user.id
        expect(response.status).to eq 302
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

  describe 'update' do
    context 'with valid email' do
      before { sign_in user }

      it 'allow user ti change email' do
        put :update, id: user.id, user: { email: 'some_email@ex.com' }
        expect(response.status).to eq 200
        expect(user.reload.email).to eq 'some_email@ex.com'
      end
    end

    context 'with invalid email' do
      before { sign_in user }

      it 'returns an error' do
        put :update, id: user.id, user: { email: another_user.email }
        expect(response.status).to eq 422
      end
    end
  end
end
