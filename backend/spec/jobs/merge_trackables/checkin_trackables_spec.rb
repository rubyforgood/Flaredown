require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::CheckinTrackables do
  let(:user) { create(:user) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::PatternIncludes.clear
      example.run
    end
  end

  # Tags and foods live as id arrays on the check-in itself; everything else lives in a
  # separate Checkin::* record. The job branches on Checkin::FIELD_TYPE to tell them apart.
  context "for a type held as an id array on the check-in" do
    let(:parent) { create(:tag) }
    let(:duplicate) { create(:tag) }

    it "rewrites the array to point at the parent" do
      checkin = create(:checkin, user_id: user.id, tag_ids: [duplicate.id])

      described_class.new.perform("tag", parent.id, [duplicate.id])

      expect(checkin.reload.tag_ids).to eq [parent.id]
    end

    it "does not list the parent twice when a check-in holds both" do
      checkin = create(:checkin, user_id: user.id, tag_ids: [parent.id, duplicate.id])

      described_class.new.perform("tag", parent.id, [duplicate.id])

      expect(checkin.reload.tag_ids).to eq [parent.id]
    end
  end

  context "for a type held in its own record" do
    let(:parent) { create(:condition) }
    let(:duplicate) { create(:condition) }

    it "repoints the record at the parent" do
      checkin = create(:checkin, user_id: user.id)
      checkin_condition = Checkin::Condition.create!(checkin_id: checkin.id, condition_id: duplicate.id, value: 3)

      described_class.new.perform("condition", parent.id, [duplicate.id])

      expect(checkin_condition.reload.condition_id).to eq parent.id
    end

    it "leaves records pointing elsewhere untouched" do
      other = create(:condition)
      checkin = create(:checkin, user_id: user.id)
      checkin_condition = Checkin::Condition.create!(checkin_id: checkin.id, condition_id: other.id, value: 1)

      described_class.new.perform("condition", parent.id, [duplicate.id])

      expect(checkin_condition.reload.condition_id).to eq other.id
    end
  end

  it "hands off to PatternIncludes" do
    parent = create(:condition)
    duplicate = create(:condition)

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(MergeTrackables::PatternIncludes.jobs.first["args"])
      .to eq ["condition", parent.id, [duplicate.id]]
  end
end
