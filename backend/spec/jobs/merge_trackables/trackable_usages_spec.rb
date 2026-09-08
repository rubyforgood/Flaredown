require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::TrackableUsages do
  let(:user) { create(:user) }
  let(:parent) { create(:condition) }
  let(:duplicate) { create(:condition) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::Trackings.clear
      example.run
    end
  end

  context "when the user has no usage of the parent yet" do
    it "moves the usage across" do
      usage = create(:trackable_usage, user: user, trackable: duplicate)

      described_class.new.perform("condition", parent.id, [duplicate.id])

      expect(usage.reload.trackable_id).to eq parent.id
    end

    it "increments the parent's usage counter" do
      create(:trackable_usage, user: user, trackable: duplicate)

      expect { described_class.new.perform("condition", parent.id, [duplicate.id]) }
        .to change { parent.reload.trackable_usages_count }.by(1)
    end
  end

  context "when the user already has a usage of the parent" do
    it "folds the counts together" do
      parent_usage = create(:trackable_usage, user: user, trackable: parent, count: 2)
      create(:trackable_usage, user: user, trackable: duplicate, count: 3)

      described_class.new.perform("condition", parent.id, [duplicate.id])

      expect(parent_usage.reload.count).to eq 5
    end

    it "destroys the duplicate usage" do
      create(:trackable_usage, user: user, trackable: parent, count: 2)
      duplicate_usage = create(:trackable_usage, user: user, trackable: duplicate, count: 3)

      described_class.new.perform("condition", parent.id, [duplicate.id])

      expect(TrackableUsage.exists?(duplicate_usage.id)).to be false
    end
  end

  it "treats each user separately" do
    someone_else = create(:user)
    create(:trackable_usage, user: user, trackable: parent, count: 2)
    their_usage = create(:trackable_usage, user: someone_else, trackable: duplicate, count: 4)

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(their_usage.reload.trackable_id).to eq parent.id
    expect(their_usage.reload.count).to eq 4
  end

  it "hands off to Trackings" do
    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(MergeTrackables::Trackings.jobs.first["args"])
      .to eq ["condition", parent.id, [duplicate.id]]
  end
end
