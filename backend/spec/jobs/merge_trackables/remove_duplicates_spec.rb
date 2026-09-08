require "rails_helper"

RSpec.describe MergeTrackables::RemoveDuplicates do
  let!(:parent) { create(:condition) }
  let!(:duplicate) { create(:condition) }

  it "destroys the duplicates it is given" do
    described_class.new.perform("condition", [duplicate.id])

    expect(Condition.exists?(duplicate.id)).to be false
  end

  it "leaves the parent alone" do
    described_class.new.perform("condition", [duplicate.id])

    expect(Condition.exists?(parent.id)).to be true
  end

  it "does nothing when there are no duplicates left" do
    expect { described_class.new.perform("condition", []) }
      .not_to change { Condition.count }
  end

  it "works for any trackable type" do
    symptom = create(:symptom)

    described_class.new.perform("symptom", [symptom.id])

    expect(Symptom.exists?(symptom.id)).to be false
  end
end
