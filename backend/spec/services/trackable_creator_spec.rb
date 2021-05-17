require "rails_helper"

RSpec.describe TrackableCreator do
  context "for Condition" do
    let!(:user) { create(:user) }
    let!(:condition_name) { "coding addiction" }
    let!(:trackable) { Condition.new(name: condition_name, global: false) }

    subject { TrackableCreator.new(trackable, user).create! }

    context "when no same condition exists" do
      it "creates new non-global condition and associates to user" do
        expect(subject.global?).to be false
        expect(UserCondition.find_by(user_id: user.id, condition_id: subject.id)).to be_present
      end
    end
    context "when global same condition exists" do
      let!(:same_condition) { create(:condition, name: condition_name.titleize) }
      it "returns existing condition" do
        expect(subject.id).to eq same_condition.id
      end
    end
    context "when non-global same condition exists" do
      let!(:same_condition) { create(:user_condition).condition }
      before { same_condition.update_attributes!(name: condition_name.titleize) }
      it "returns existing condition and associates it to user" do
        expect(subject.id).to eq same_condition.id
        expect(UserCondition.find_by(user_id: user.id, condition_id: same_condition.id)).to be_present
      end
    end
  end
end
