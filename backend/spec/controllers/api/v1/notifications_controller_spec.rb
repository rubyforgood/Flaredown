require "rails_helper"

RSpec.describe Api::V1::NotificationsController do
  let(:user) { create(:user) }
  let(:notifier) { create(:user) }
  let(:notified_post) { create(:post, encrypted_user_id: user.encrypted_id) }

  let!(:notification) do
    create(:notification,
      kind: "comment",
      notificateable: notified_post,
      encrypted_user_id: notifier.encrypted_id,
      encrypted_notify_user_id: user.encrypted_id)
  end

  before { sign_in user }

  describe "index" do
    it "returns the signed-in user's notifications grouped by kind and subject" do
      get :index

      expect(response).to have_http_status :ok
      expect(response_body[:notifications].size).to eq 1
      expect(response_body[:notifications].first[:kind]).to eq "comment"
      expect(response_body[:notifications].first[:count]).to eq 1
    end

    it "collapses repeated notifications on the same subject into a count" do
      create(:notification,
        kind: "comment",
        notificateable: notified_post,
        encrypted_user_id: create(:user).encrypted_id,
        encrypted_notify_user_id: user.encrypted_id)

      get :index

      expect(response_body[:notifications].size).to eq 1
      expect(response_body[:notifications].first[:count]).to eq 2
    end

    it "does not return notifications addressed to somebody else" do
      create(:notification,
        kind: "reaction",
        notificateable: create(:post),
        encrypted_notify_user_id: create(:user).encrypted_id)

      get :index

      expect(response_body[:notifications].map { |n| n[:kind] }).to eq ["comment"]
    end
  end

  describe "update" do
    let(:subject_params) do
      {notificateable_id: notified_post.id.to_s, notificateable_type: "post"}
    end

    it "marks the notifications for that subject as read" do
      put :update, params: subject_params

      expect(response).to have_http_status :ok
      expect(notification.reload.unread).to be false
    end

    it "returns the regrouped notifications" do
      put :update, params: subject_params

      expect(response_body[:notifications].first[:unread]).to be false
    end

    it "leaves another user's notifications on the same subject alone" do
      theirs = create(:notification,
        kind: "comment",
        notificateable: notified_post,
        encrypted_notify_user_id: create(:user).encrypted_id)

      put :update, params: subject_params

      expect(theirs.reload.unread).to be true
    end
  end

  describe "destroy" do
    it "removes the notifications for that subject" do
      expect {
        delete :destroy, params: {
          notificateable_id: notified_post.id.to_s,
          notificateable_type: "post"
        }
      }.to change { Notification.count }.by(-1)

      expect(response).to have_http_status :no_content
    end
  end
end
