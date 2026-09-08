require "rails_helper"
require "sidekiq/testing"

# SES posts here over SNS. The message type arrives in a header, and the body is read
# raw rather than through strong parameters.
RSpec.describe Api::V1::AwsSesController do
  around do |example|
    Sidekiq::Testing.fake! do
      EmailRejectDispatcher.clear
      example.run
    end
  end

  describe "notification" do
    it "hands a delivery notification to the dispatcher, unauthenticated" do
      request.headers["x-amz-sns-message-type"] = "Notification"
      request.headers["CONTENT_TYPE"] = "application/json"

      post :notification, body: {"notificationType" => "Bounce"}.to_json

      expect(response).to have_http_status :ok
      expect(EmailRejectDispatcher.jobs.size).to eq 1
    end

    it "passes the body through untouched, since the dispatcher parses it itself" do
      raw = {"notificationType" => "Complaint"}.to_json
      request.headers["x-amz-sns-message-type"] = "Notification"
      request.headers["CONTENT_TYPE"] = "application/json"

      post :notification, body: raw

      expect(EmailRejectDispatcher.jobs.first["args"]).to eq [raw]
    end

    it "confirms a subscription by fetching the URL SNS supplies" do
      request.headers["x-amz-sns-message-type"] = "SubscriptionConfirmation"
      request.headers["CONTENT_TYPE"] = "application/json"
      confirm_url = "https://sns.example.com/confirm?token=abc"

      expect(controller).to receive(:open).with(confirm_url)

      post :notification, body: {"SubscribeURL" => confirm_url}.to_json

      expect(response).to have_http_status :ok
      expect(EmailRejectDispatcher.jobs).to be_empty
    end
  end
end
