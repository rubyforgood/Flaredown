require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::TopicFollowing do
  let(:user) { create(:user) }
  let(:parent) { create(:condition) }
  let(:duplicate) { create(:condition) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::CheckinTrackables.clear
      example.run
    end
  end

  it "repoints a following from the duplicate to the parent" do
    following = ::TopicFollowing.create!(
      encrypted_user_id: user.encrypted_id,
      condition_ids: [duplicate.id]
    )

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(following.reload.condition_ids).to eq [parent.id]
  end

  it "does not list the parent twice when a following holds both" do
    following = ::TopicFollowing.create!(
      encrypted_user_id: user.encrypted_id,
      condition_ids: [parent.id, duplicate.id]
    )

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(following.reload.condition_ids).to eq [parent.id]
  end

  it "leaves a following that holds neither untouched" do
    other = create(:condition)
    following = ::TopicFollowing.create!(
      encrypted_user_id: user.encrypted_id,
      condition_ids: [other.id]
    )

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(following.reload.condition_ids).to eq [other.id]
  end

  it "hands off to CheckinTrackables" do
    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(MergeTrackables::CheckinTrackables.jobs.first["args"])
      .to eq ["condition", parent.id, [duplicate.id]]
  end
end
