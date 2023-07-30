require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context "for treatments" do
    let!(:global_treatment) { create(:treatment) }
    let!(:personal_treatment) { create(:user_treatment, user: user).treatment }
    let!(:another_user_treatment) { create(:user_treatment).treatment }
    let!(:popular_treatment) { create(:treatment, :personal) }
    before { create_list(:user_treatment, Flaredown.config.trackables_min_popularity, treatment: popular_treatment) }

    context "index" do
      it "allow to index personal treatments" do
        is_expected.to be_able_to(:index, personal_treatment)
      end

      it "allow to index global treatments" do
        is_expected.to be_able_to(:index, global_treatment)
      end

      it "don't allow to index another user's personal treatment" do
        is_expected.not_to be_able_to(:index, another_user_treatment)
      end
    end

    context "show" do
      it "allow to show global treatments" do
        is_expected.to be_able_to(:show, global_treatment)
      end
      it "allow to show personal treatments" do
        is_expected.to be_able_to(:show, personal_treatment)
      end
      it "allow to show popular treatments" do
        is_expected.to be_able_to(:show, popular_treatment)
      end
      it "allow to show another user's personal treatments" do
        is_expected.to be_able_to(:show, another_user_treatment)
      end
    end

    context "manage" do
      it "allow to manage user's personal treatments" do
        is_expected.to be_able_to(:manage, personal_treatment)
      end
      it "don't allow to manage another user's personal treatments" do
        is_expected.not_to be_able_to(:manage, another_user_treatment)
      end
    end

    context "create" do
      let(:new_treatment) { Treatment.new(global: false) }
      let(:new_global_treatment) { Treatment.new }
      it "allow to create non-global treatments" do
        is_expected.to be_able_to(:create, new_treatment)
      end
      it "don't allow to create global treatments" do
        is_expected.not_to be_able_to(:create, new_global_treatment)
      end
    end

    context "popular treatmnets" do
      before { create_list(:user_treatment, Flaredown.config.trackables_min_popularity, treatment: popular_treatment) }
      let(:popular_treatment_ids) { Ability.new(user).send(:popular_trackable_ids, "Treatment") }

      it { expect(popular_treatment_ids).to eq([popular_treatment.id]) }
    end
  end
end
