require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController do
  let(:attributes) do
    {
      email: 'user@example.com',
      password: 'secret123',
      password_confirmation: 'secret123',
      screen_name: 'user',
      captcha_response: 'dummy-captcha-response'
    }
  end
  let(:user) { create(:user, attributes.slice(:email, :password, :password_confirmation)) }

  describe 'create' do
    let(:registration) do
      new_registration = Registration.new(
        ActionController::Parameters.new(registration: attributes)
      )
      new_registration.user = user
      new_registration
    end

    before { allow(Registration).to receive(:create!).and_return(registration) }

    it 'registers a new user' do
      post :create, registration: attributes
      expect(response.status).to eq 200
      user = response_body[:users][0]
      expect(user[:email]).to eq attributes[:email]
    end
  end

  let(:attributes_for_destroy) do
    {
      delete_reason: "Reason",
      email: user.email
    }
  end

  describe 'destroy' do
    let!(:checkin_with_ref) do
      create(:checkin, date: Date.parse('2016-01-06'), user_id: user.id, position_id: 1, postal_code: '123456789')
    end

    it 'removes user and it\'s profile' do
      delete :destroy, attributes_for_destroy
      expect(response.status).to eq 200
      expect(Feedback.last.delete_reason).to eq attributes_for_destroy[:delete_reason]
      expect(checkin_with_ref.reload.postal_code).to be_nil
      expect(checkin_with_ref.reload.position).to be_nil
      expect(User.find_by(id: user.id)).to be_nil
      expect(Profile.find_by(user_id: user.id)).to be_nil
    end
  end
end
