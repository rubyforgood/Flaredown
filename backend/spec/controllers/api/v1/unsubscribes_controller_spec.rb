require "rails_helper"

RSpec.describe Api::V1::UnsubscribesController do
  let(:user) { create(:user) }
  let(:profile) { user.profile }

  before do
    profile.update!(notify: true, notify_top_posts: true, checkin_reminder: true)
  end

  describe "update" do
    it "turns off discussion notifications by default" do
      put :update, params: {notify_token: profile.notify_token}

      expect(response).to have_http_status :ok
      expect(profile.reload.notify).to be false
    end

    it "turns off only the top-posts digest when asked" do
      put :update, params: {notify_token: profile.notify_token, notify_top_posts: true}

      expect(profile.reload.notify_top_posts).to be false
      expect(profile.reload.notify).to be true
    end

    it "turns off only the check-in reminder when asked" do
      put :update, params: {notify_token: profile.notify_token, stop_remind: true}

      expect(profile.reload.checkin_reminder).to be false
      expect(profile.reload.notify).to be true
    end

    # No sign-in is required -- the token from the email is the only credential, which is
    # what lets an unsubscribe link work straight from a mail client.
    it "works without signing in" do
      put :update, params: {notify_token: profile.notify_token}

      expect(response).to have_http_status :ok
    end

    it "responds with null for an unrecognised token, changing nothing" do
      put :update, params: {notify_token: "not-a-real-token"}

      expect(response).to have_http_status :ok
      expect(response.body).to eq "null"
      expect(profile.reload.notify).to be true
    end
  end
end
