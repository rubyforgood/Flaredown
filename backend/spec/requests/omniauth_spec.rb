require "rails_helper"

# The Ember client does not use OmniAuth's request phase: it signs the user in
# with Facebook's JavaScript SDK and then POSTs straight to the callback path,
# where the strategy reads the `fbsr_<app_id>` cookie the SDK left behind. These
# examples cover that path through the real middleware stack.
RSpec.describe "OmniAuth", type: :request do
  let(:user) { create(:user) }

  around do |example|
    OmniAuth.config.test_mode = true
    example.run
  ensure
    OmniAuth.config.mock_auth.delete(:facebook)
    OmniAuth.config.test_mode = false
  end

  it "signs a user in through the facebook callback" do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "1234567890",
      info: {email: user.email, name: "Test User"}
    )

    post "/api/auth/facebook/callback"

    expect(response.status).to eq 200
    expect(response_body[:user_id]).to eq user.id
    expect(response_body[:token]).to eq user.authentication_token
  end

  it "renders the failure message when the provider rejects the request" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

    post "/api/auth/facebook/callback"

    expect(response.status).to eq 401
    expect(response_body[:errors]).to eq "Invalid credentials"
  end
end
