require "rails_helper"

# The Ember client does not use OmniAuth's request phase: it signs the user in
# with Facebook's JavaScript SDK and then POSTs straight to the callback path,
# where the strategy reads the `fbsr_<app_id>` cookie the SDK left behind. These
# examples cover that path through the real middleware stack.
RSpec.describe "OmniAuth", type: :request do
  let(:user) { create(:user) }
  let(:app_id) { ENV["FACEBOOK_APP_ID"] }
  let(:app_secret) { ENV["FACEBOOK_APP_SECRET"] }

  around do |example|
    example.run
  ensure
    OmniAuth.config.mock_auth.delete(:facebook)
    OmniAuth.config.test_mode = false
  end

  def mock_facebook(response)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = response
  end

  it "signs a user in through the facebook callback" do
    mock_facebook(OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "1234567890",
      info: {email: user.email, name: "Test User"}
    ))

    post "/api/auth/facebook/callback"

    expect(response.status).to eq 200
    expect(response_body[:user_id]).to eq user.id
    expect(response_body[:token]).to eq user.authentication_token
  end

  it "renders the failure message when the provider rejects the request" do
    mock_facebook(:invalid_credentials)

    post "/api/auth/facebook/callback"

    expect(response.status).to eq 401
    expect(response_body[:errors]).to eq "Invalid credentials"
  end

  describe "the token exchange" do
    # OmniAuth's test mode short-circuits before the strategy talks to Facebook,
    # so this drives the real callback phase instead. It is the only coverage of
    # how the client credentials reach the token endpoint, and oauth2 2.0 changed
    # the default for that (see config/initializers/devise.rb).
    let(:graph) { "https://graph.facebook.com/v24.0" }

    # The cookie the Facebook JavaScript SDK leaves behind: a payload carrying an
    # authorization code, signed with the app secret.
    let(:signed_request) do
      payload = base64_url(JSON.dump("algorithm" => "HMAC-SHA256", "code" => "fb-auth-code", "user_id" => "1234567890"))
      "#{base64_url(OpenSSL::HMAC.digest("SHA256", app_secret, payload))}.#{payload}"
    end

    def base64_url(value)
      Base64.urlsafe_encode64(value, padding: false)
    end

    before do
      stub_request(:get, "#{graph}/me")
        .with(query: hash_including("fields" => "name,email"))
        .to_return(
          status: 200,
          body: {id: "1234567890", name: "Test User", email: user.email}.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      cookies["fbsr_#{app_id}"] = signed_request
    end

    it "sends the client credentials to Facebook in the request body" do
      token_request = stub_request(:post, "#{graph}/oauth/access_token")
        .with(body: hash_including(
          "client_id" => app_id,
          "client_secret" => app_secret,
          "code" => "fb-auth-code"
        ))
        .to_return(
          status: 200,
          body: {access_token: "fb-access-token", token_type: "bearer"}.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      post "/api/auth/facebook/callback"

      expect(token_request).to have_been_requested
      expect(response.status).to eq 200
      expect(response_body[:user_id]).to eq user.id
    end
  end
end
