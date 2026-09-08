require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::Trackings do
  let(:parent) { create(:condition) }
  let(:duplicate) { create(:condition) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::TopicFollowing.clear
      example.run
    end
  end

  it "repoints a tracking from the duplicate to the parent" do
    tracking = create(:tracking, :active, trackable: duplicate)

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(tracking.reload.trackable_id).to eq parent.id
  end

  # The lookup is scoped by trackable_type as well as id, so a symptom that happens to
  # share an id with a merged condition is not swept up in the merge.
  it "leaves trackings of a different trackable type alone" do
    symptom = create(:symptom)
    tracking = create(:tracking, :active, trackable: symptom)

    described_class.new.perform("condition", parent.id, [symptom.id])

    expect(tracking.reload.trackable_id).to eq symptom.id
    expect(tracking.reload.trackable_type).to eq "Symptom"
  end

  it "hands off to TopicFollowing" do
    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(MergeTrackables::TopicFollowing.jobs.first["args"])
      .to eq ["condition", parent.id, [duplicate.id]]
  end
end
