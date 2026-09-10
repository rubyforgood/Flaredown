require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::Dispatcher do
  let(:enqueued) { MergeTrackables::UserTrackableAssociation.jobs }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::UserTrackableAssociation.clear
      example.run
    end
  end

  context "given a specific name" do
    it "starts a merge when two trackables share it" do
      create(:condition, name: "Asthma")
      create(:condition, name: "Asthma")

      described_class.new.perform("condition", "Asthma")

      expect(enqueued.size).to eq 1
    end

    it "matches regardless of case" do
      create(:condition, name: "Asthma")
      create(:condition, name: "asthma")

      described_class.new.perform("condition", "ASTHMA")

      expect(enqueued.size).to eq 1
    end

    # The escaped name has its spaces swapped for `\s+`, so spacing differences match.
    it "matches across differing whitespace" do
      create(:condition, name: "Crohn's disease")
      create(:condition, name: "Crohn's    disease")

      described_class.new.perform("condition", "Crohn's disease")

      expect(enqueued.size).to eq 1
    end

    it "does nothing when the name is unique" do
      create(:condition, name: "Asthma")

      described_class.new.perform("condition", "Asthma")

      expect(enqueued).to be_empty
    end

    it "does not match a name that merely contains the search term" do
      create(:condition, name: "Asthma")
      create(:condition, name: "Severe asthma")

      described_class.new.perform("condition", "Asthma")

      expect(enqueued).to be_empty
    end

    it "keeps the most-used trackable as the parent" do
      rarely_used = create(:condition, name: "Asthma")
      often_used = create(:condition, name: "Asthma")
      often_used.update!(trackable_usages_count: 5)

      described_class.new.perform("condition", "Asthma")

      _type, parent_id, rest_ids = enqueued.first["args"]
      expect(parent_id).to eq often_used.id
      expect(rest_ids).to eq [rarely_used.id]
    end

    it "deletes the duplicate's translation so it stops matching" do
      create(:condition, name: "Asthma")
      duplicate = create(:condition, name: "Asthma")

      described_class.new.perform("condition", "Asthma")

      expect(Condition::Translation.where(condition_id: duplicate.id)).to be_empty
    end
  end

  context "given no name" do
    it "scans every translation and merges what it finds" do
      create(:condition, name: "Asthma")
      create(:condition, name: "Asthma")
      create(:condition, name: "Eczema")

      described_class.new.perform("condition")

      expect(enqueued.size).to eq 1
    end

    it "does nothing when every name is distinct" do
      create(:condition, name: "Asthma")
      create(:condition, name: "Eczema")

      described_class.new.perform("condition")

      expect(enqueued).to be_empty
    end
  end

  it "searches foods by long_desc rather than name" do
    create(:food, long_desc: "Cheddar cheese")
    create(:food, long_desc: "cheddar cheese")

    described_class.new.perform("food", "Cheddar cheese")

    expect(enqueued.size).to eq 1
  end
end
