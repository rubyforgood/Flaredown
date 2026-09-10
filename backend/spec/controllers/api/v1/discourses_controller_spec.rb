require "rails_helper"

RSpec.describe Api::V1::DiscoursesController do
  let(:user) { create(:user) }
  let(:auth_url) { "https://community.example.com/session/sso_login" }
  let(:secret) { "discourse-shared-secret" }
  let(:sso) { Base64.encode64("nonce=abc123&return_sso_url=https://community.example.com") }
  let(:signature) { OpenSSL::HMAC.hexdigest("sha256", secret, sso) }

  before { sign_in user }

  around do |example|
    with_env("DISCOURSE_AUTH_URL" => auth_url, "DISCOURSE_SECRET" => secret) { example.run }
  end

  describe "create" do
    context "when the signature matches the payload" do
      it "returns a signed URL carrying the user's identity" do
        post :create, params: {sso: sso, sig: signature}

        url = URI.parse(response_body[:url])
        query = Rack::Utils.parse_query(url.query)
        payload = Base64.decode64(query["sso"])

        expect(url.host).to eq "community.example.com"
        expect(payload).to include "email=#{user.email}"
        expect(payload).to include "external_id=#{user.external_id}"
      end

      it "signs the returned payload with the shared secret" do
        post :create, params: {sso: sso, sig: signature}

        query = Rack::Utils.parse_query(URI.parse(response_body[:url]).query)

        expect(query["sig"]).to eq OpenSSL::HMAC.hexdigest("sha256", secret, query["sso"])
      end
    end

    context "when the signature does not match the payload" do
      it "returns the bare auth URL, leaking no identity" do
        post :create, params: {sso: sso, sig: "not-the-right-signature"}

        expect(response_body[:url]).to eq auth_url
      end
    end
  end
end
