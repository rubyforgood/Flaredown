require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController do

  describe 'create' do
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

end
