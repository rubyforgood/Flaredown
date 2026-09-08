require "rails_helper"

RSpec.describe Api::V1::PushersController do
  let(:user) { create(:user) }
  let(:socket_id) { "123.456" }

  before { sign_in user }

  describe "create" do
    it "returns the payload Pusher signed for this user's channel" do
      allow(Flaredown.pusher).to receive(:authenticate!)
        .with(user, socket_id)
        .and_return({auth: "pusher-key:signature"})

      post :create, params: {socket_id: socket_id}

      expect(response).to have_http_status :ok
      expect(response_body[:auth]).to eq "pusher-key:signature"
    end

    it "returns 403 when Pusher rejects the socket" do
      allow(Flaredown.pusher).to receive(:authenticate!).and_raise(Pusher::Error)

      post :create, params: {socket_id: socket_id}

      expect(response.status).to eq 403
      expect(response_body[:errors]).to eq "Bad authentication"
    end

    # `socket_id` is fetched with `params.require`, and the controller's bare `rescue`
    # swallows the resulting ParameterMissing along with everything else -- so a
    # malformed request is reported as a rejected one.
    it "returns 403 when socket_id is missing" do
      post :create

      expect(response.status).to eq 403
      expect(response_body[:errors]).to eq "Bad authentication"
    end
  end
end
