require "rails_helper"
require "sidekiq/testing"

RSpec.describe NotificationDispatcher do
  around do |example|
    Sidekiq::Testing.fake! do
      GroupNotifiersPerUser.clear
      example.run
    end
  end

  def notify(user)
    create(:notification,
      kind: "comment",
      notificateable: create(:post),
      encrypted_notify_user_id: user.encrypted_id)
  end

  it "enqueues one grouping job per user awaiting notifications" do
    first = create(:user)
    second = create(:user)
    notify(first)
    notify(second)

    described_class.new.perform

    expect(GroupNotifiersPerUser.jobs.size).to eq 2
  end

  # The point of the job: a user with five pending notifications gets one email, not five.
  it "enqueues only once for a user with several notifications" do
    user = create(:user)
    3.times { notify(user) }

    described_class.new.perform

    expect(GroupNotifiersPerUser.jobs.size).to eq 1
    expect(GroupNotifiersPerUser.jobs.first["args"]).to eq [user.encrypted_id]
  end

  it "enqueues nothing when there are no notifications" do
    described_class.new.perform

    expect(GroupNotifiersPerUser.jobs).to be_empty
  end
end
