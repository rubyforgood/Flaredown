require 'rails_helper'

RSpec.describe Api::V1::PasswordsController do
  let(:user) { create(:user, password: 'ValidPassword123', password_confirmation: 'ValidPassword123') }

  describe 'update' do
    context 'when no user logged-in' do
      context 'when missing token' do
        it 'returns 422  (Unprocessable Entity)' do
          put :update, id: 1
          expect(response.status).to eq 422
        end
      end
      context 'when provide token' do
        it 'returns password ' do
          put :update, id: 1, token: '123'
          expect(response.status).to eq 422
        end
      end
    end

    context 'when user logged-in' do
      before { sign_in user }

      context 'when provide right params' do
        it 'update password' do
          put(
            :update,
            id: user.id,
            password: {
              current_password: 'ValidPassword123',
              password: 'password123',
              password_confirmation: 'password123'
            }
          )
          expect(response_body[:password][:email]).to eq user.email
        end
      end

      context 'when password confirmation is wrong' do
        it 'returns 422  (Unprocessable Entity)' do
          put :update, id: user.id, password: { password: 'password123', password_confirmation: 'password' }
          expect(response.status).to eq 422
        end
      end

      context 'when current password is wrong' do
        it 'returns 422  (Unprocessable Entity)' do
          put(
            :update,
            id: user.id,
            password: {
              current_password: 'InvalidPassword123',
              password: 'password123',
              password_confirmation: 'password123'
            }
          )

          expect(response.status).to eq 422
        end
      end

    end
  end
end
