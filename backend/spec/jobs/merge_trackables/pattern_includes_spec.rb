require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::PatternIncludes do
  let(:user) { create(:user) }
  let(:parent) { create(:condition) }
  let(:duplicate) { create(:condition) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::PostTrackables.clear
      example.run
    end
  end

  it "repoints a pattern's include at the parent and relabels it" do
    pattern = create(:pattern,
      encrypted_user_id: user.encrypted_id,
      includes: [{category: "conditions", id: duplicate.id, label: "old label"}])

    described_class.new.perform("condition", parent.id, [duplicate.id])

    include_entry = pattern.reload.includes.first
    expect(include_entry["id"]).to eq parent.id
    expect(include_entry["label"]).to eq parent.name
  end

  it "leaves includes in another category alone" do
    pattern = create(:pattern,
      encrypted_user_id: user.encrypted_id,
      includes: [{category: "symptoms", id: duplicate.id, label: "a symptom"}])

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(pattern.reload.includes.first["id"]).to eq duplicate.id
  end

  it "gives up when the parent no longer exists" do
    expect { described_class.new.perform("condition", -1, [duplicate.id]) }
      .not_to change { MergeTrackables::PostTrackables.jobs.size }
  end

  it "hands off to PostTrackables" do
    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(MergeTrackables::PostTrackables.jobs.first["args"])
      .to eq ["condition", parent.id, [duplicate.id]]
  end
end
