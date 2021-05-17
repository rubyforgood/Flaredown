require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context "for conditions" do
    let!(:global_condition) { create(:condition) }
    let!(:personal_condition) { create(:user_condition, user: user).condition }
    let!(:another_user_condition) { create(:user_condition).condition }
    let!(:popular_condition) { create(:condition, :personal) }
    before { create_list(:user_condition, Flaredown.config.trackables_min_popularity, condition: popular_condition) }

    context "index" do
      it "allow to index personal condition" do
        is_expected.to be_able_to(:index, personal_condition)
      end

      it "allow to index global conditions" do
        is_expected.to be_able_to(:index, global_condition)
      end

      it "don't allow to index another user's personal condition" do
        is_expected.not_to be_able_to(:index, another_user_condition)
      end
    end

    context "show" do
      it "allow to show global conditions" do
        is_expected.to be_able_to(:show, global_condition)
      end
      it "allow to show personal conditions" do
        is_expected.to be_able_to(:show, personal_condition)
      end
      it "allow to show popular conditions" do
        is_expected.to be_able_to(:show, popular_condition)
      end
      it "allow to show another user's personal condition" do
        is_expected.to be_able_to(:show, another_user_condition)
      end
    end

    context "manage" do
      it "allow to manage user's personal conditions" do
        is_expected.to be_able_to(:manage, personal_condition)
      end
      it "don't allow to manage another user's personal conditions" do
        is_expected.not_to be_able_to(:manage, another_user_condition)
      end
    end

    context "create" do
      let(:new_condition) { Condition.new(global: false) }
      let(:new_global_condition) { Condition.new }
      it "allow to create non-global conditions" do
        is_expected.to be_able_to(:create, new_condition)
      end
      it "don't allow to create global conditions" do
        is_expected.not_to be_able_to(:create, new_global_condition)
      end
    end

    context "popular conditions" do
      before { create_list(:user_condition, Flaredown.config.trackables_min_popularity, condition: popular_condition) }
      let(:popular_condition_ids) { Ability.new(user).send("popular_trackable_ids", "Condition") }

      it { expect(popular_condition_ids).to eq([popular_condition.id]) }
    end
  end
end
