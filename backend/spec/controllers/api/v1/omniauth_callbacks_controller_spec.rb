require "rails_helper"

RSpec.describe Api::V1::OmniauthCallbacksController do
  let(:user) { create(:user) }

  def auth_hash_for(email)
    OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "1234567890",
      info: {email: email, name: "Test User"}
    )
  end

  describe "facebook" do
    before { request.env["omniauth.auth"] = auth_hash_for(email) }

    context "when the provider's email belongs to a registered user" do
      let(:email) { user.email }

      it "responds with that user's session" do
        post :facebook

        expect(response.status).to eq 200
        expect(response_body[:user_id]).to eq user.id
        expect(response_body[:email]).to eq user.email
        expect(response_body[:token]).to eq user.authentication_token
      end
    end

    context "when no user has the provider's email" do
      let(:email) { "stranger@example.com" }

      it "responds with 401" do
        post :facebook

        expect(response.status).to eq 401
        expect(response_body[:errors]).to eq "User not found"
      end
    end

    context "when the user has not accepted their invitation" do
      let(:email) { "invited@example.com" }

      before { User.invite!(email: email) }

      it "responds with 401" do
        post :facebook

        expect(response.status).to eq 401
        expect(response_body[:errors]).to eq "User not found"
      end
    end
  end
end
