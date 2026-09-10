require "rails_helper"

RSpec.describe Api::V1::SessionsController do
  let!(:user) { create(:user, email: "member@flaredown.com", password: "password123") }

  # SessionSerializer#settings reads DISCOURSE_URL with a bare `ENV.fetch` and no
  # default, so it raises KeyError wherever that variable is absent -- which is CI,
  # since `.env` is gitignored. Set it rather than depend on the environment.
  around do |example|
    with_env("DISCOURSE_URL" => "https://community.example.com") { example.run }
  end

  describe "create" do
    it "returns the user with an authentication token on correct credentials" do
      post :create, params: {user: {email: user.email, password: "password123"}}

      expect(response).to have_http_status :ok
      expect(response_body[:email]).to eq user.email
      expect(response_body[:token]).to eq user.authentication_token
    end

    it "returns the client settings alongside the session" do
      post :create, params: {user: {email: user.email, password: "password123"}}

      settings = response_body[:settings]
      expect(settings[:discourse_url]).to eq "https://community.example.com"
      expect(settings[:notification_channel]).to eq user.notification_channel
    end

    it "renders without a root key, since the client reads the session flat" do
      post :create, params: {user: {email: user.email, password: "password123"}}

      expect(response_body).not_to have_key "user"
    end

    it "rejects a wrong password" do
      post :create, params: {user: {email: user.email, password: "wrong"}}

      expect(response.status).to eq 401
      expect(response_body[:errors]).to eq ["invalid email or password"]
    end

    it "rejects an unknown email" do
      post :create, params: {user: {email: "nobody@flaredown.com", password: "password123"}}

      expect(response.status).to eq 401
      expect(response_body[:errors]).to eq ["invalid email or password"]
    end

    # The same 401 and wording for a missing user and a wrong password, so the endpoint
    # does not reveal whether an address is registered.
    it "rejects a request with no user params at all" do
      post :create

      expect(response.status).to eq 401
      expect(response_body[:errors]).to eq ["missing information"]
    end
  end
end
