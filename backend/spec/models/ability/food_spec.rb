require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context "for foods" do
    let!(:global_food) { create(:food) }
    let!(:personal_food) { create(:user_food, user: user).food }
    let!(:another_user_food) { create(:user_food).food }
    let!(:popular_food) { create(:food, :personal) }

    before { create_list(:user_food, Flaredown.config.trackables_min_popularity, food: popular_food) }

    context "index" do
      it "allow to index personal food" do
        is_expected.to be_able_to(:index, personal_food)
      end
      it "allow to index global food" do
        is_expected.to be_able_to(:index, global_food)
      end
      it "don't allow to index another user's personal food" do
        is_expected.not_to be_able_to(:index, another_user_food)
      end
    end

    context "show" do
      it "allow to show global food" do
        is_expected.to be_able_to(:show, global_food)
      end
      it "allow to show personal food" do
        is_expected.to be_able_to(:show, personal_food)
      end
      it "allow to show another user's personal food" do
        is_expected.to be_able_to(:show, another_user_food)
      end
    end

    context "manage" do
      it "allow to manage user's personal food" do
        is_expected.to be_able_to(:manage, personal_food)
      end
      it "don't allow to manage another user's personal food" do
        is_expected.not_to be_able_to(:manage, another_user_food)
      end
    end

    context "create" do
      let(:new_food) { Food.new(global: false) }
      let(:new_global_food) { Food.new }
      it "allow to create non-global food" do
        is_expected.to be_able_to(:create, new_food)
      end
      it "don't allow to create global food" do
        is_expected.not_to be_able_to(:create, new_global_food)
      end
    end
  end
end
