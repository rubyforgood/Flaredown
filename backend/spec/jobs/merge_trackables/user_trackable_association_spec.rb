require "rails_helper"
require "sidekiq/testing"

RSpec.describe MergeTrackables::UserTrackableAssociation do
  let(:user) { create(:user) }
  let(:parent) { create(:condition) }
  let(:duplicate) { create(:condition) }

  around do |example|
    Sidekiq::Testing.fake! do
      MergeTrackables::TrackableUsages.clear
      example.run
    end
  end

  it "repoints the user's association at the parent" do
    association = UserCondition.create!(user: user, condition: duplicate)

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(association.reload.condition_id).to eq parent.id
  end

  it "destroys the duplicate association when the user already has the parent" do
    UserCondition.create!(user: user, condition: parent)
    duplicate_association = UserCondition.create!(user: user, condition: duplicate)

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(UserCondition.exists?(duplicate_association.id)).to be false
  end

  it "leaves another user's association to an unrelated condition alone" do
    other = create(:condition)
    association = UserCondition.create!(user: create(:user), condition: other)

    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(association.reload.condition_id).to eq other.id
  end

  it "hands off to TrackableUsages" do
    described_class.new.perform("condition", parent.id, [duplicate.id])

    expect(MergeTrackables::TrackableUsages.jobs.first["args"])
      .to eq ["condition", parent.id, [duplicate.id]]
  end
end
