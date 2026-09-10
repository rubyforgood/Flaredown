require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::PostTrackables do
  let(:parent) { create(:symptom) }
  let(:duplicate) { create(:symptom) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::RemoveDuplicates.clear
      example.run
    end
  end

  it "repoints a post from the duplicate to the parent" do
    post = create(:post, symptom_ids: [duplicate.id])

    described_class.new.perform("symptom", parent.id, [duplicate.id])

    expect(post.reload.symptom_ids).to eq [parent.id]
  end

  it "does not list the parent twice when a post references both" do
    post = create(:post, symptom_ids: [parent.id, duplicate.id])

    described_class.new.perform("symptom", parent.id, [duplicate.id])

    expect(post.reload.symptom_ids).to eq [parent.id]
  end

  it "leaves posts that reference neither untouched" do
    other = create(:symptom)
    post = create(:post, symptom_ids: [other.id])

    described_class.new.perform("symptom", parent.id, [duplicate.id])

    expect(post.reload.symptom_ids).to eq [other.id]
  end

  it "hands off to RemoveDuplicates" do
    described_class.new.perform("symptom", parent.id, [duplicate.id])

    expect(MergeTrackables::RemoveDuplicates.jobs.size).to eq 1
    expect(MergeTrackables::RemoveDuplicates.jobs.first["args"]).to eq ["symptom", [duplicate.id]]
  end
end
