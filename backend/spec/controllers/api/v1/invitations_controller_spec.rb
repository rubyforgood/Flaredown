require "rails_helper"

RSpec.describe Api::V1::InvitationsController do
  # `invite!` returns the raw token; the digest is what gets stored. `skip_invitation`
  # keeps this from trying to send the invitation mail, which needs an SMTP From address
  # that is not configured in test.
  let!(:raw_token) do
    User.invite!(email: "invitee@flaredown.com") { |u| u.skip_invitation = true }
      .raw_invitation_token
  end

  describe "show" do
    it "returns the invitation for a valid token, without signing in" do
      get :show, params: {id: raw_token}

      expect(response).to have_http_status :ok
      expect(response_body[:invitation][:email]).to eq "invitee@flaredown.com"
    end

    it "returns 404 for a token that matches nobody" do
      get :show, params: {id: "not-a-real-token"}

      expect(response).to have_http_status :not_found
    end
  end

  describe "update" do
    it "accepts the invitation and sets the password" do
      put :update, params: {
        id: raw_token,
        invitation: {password: "newpassword1", password_confirmation: "newpassword1"}
      }

      expect(response).to have_http_status :ok

      user = User.find_by(email: "invitee@flaredown.com")
      expect(user.invitation_accepted_at).to be_present
      expect(user.valid_password?("newpassword1")).to be true
    end

    it "leaves the invitation unaccepted when the confirmation does not match" do
      put :update, params: {
        id: raw_token,
        invitation: {password: "newpassword1", password_confirmation: "different"}
      }

      expect(User.find_by(email: "invitee@flaredown.com").invitation_accepted_at).to be_nil
    end
  end
end
