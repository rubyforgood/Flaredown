require "rails_helper"
require "sidekiq/testing"

RSpec.describe EmailRejectDispatcher do
  around do |example|
    Sidekiq::Testing.fake! do
      EmailRejectJob.clear
      example.run
    end
  end

  def enqueued_recipients
    EmailRejectJob.jobs.first["args"].first
  end

  # SES delivers two shapes: a bounce notification with the mail inline, and an SNS
  # envelope whose "Message" is the notification as a JSON string.
  context "with a bounce notification delivered inline" do
    let(:payload) do
      {
        "notificationType" => "Bounce",
        "mail" => {"destination" => ["bounced@example.com"]}
      }.to_json
    end

    it "enqueues the addresses under the bounce key" do
      described_class.new.perform(payload)

      expect(enqueued_recipients).to eq({"bounce" => ["bounced@example.com"]})
    end
  end

  context "with an SNS envelope" do
    let(:payload) do
      {
        "Message" => {
          "notificationType" => "Complaint",
          "mail" => {"destination" => ["complained@example.com"]}
        }.to_json
      }.to_json
    end

    it "unwraps the message and keys the addresses by the lowercased type" do
      described_class.new.perform(payload)

      expect(enqueued_recipients).to eq({"complaint" => ["complained@example.com"]})
    end
  end

  it "enqueues nothing when the payload is neither shape" do
    described_class.new.perform({"notificationType" => "Delivery"}.to_json)

    expect(EmailRejectJob.jobs).to be_empty
  end

  it "enqueues an empty list when a bounce names no recipients" do
    described_class.new.perform({"notificationType" => "Bounce"}.to_json)

    expect(enqueued_recipients).to eq({"bounce" => []})
  end
end
