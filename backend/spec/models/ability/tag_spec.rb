require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context 'for tags' do
    let!(:global_tag) { create(:tag) }
    let!(:personal_tag) { create(:user_tag, user: user).tag }
    let!(:another_user_tag) { create(:user_tag).tag }
    let!(:popular_tag) { create(:tag, :personal) }

    before { create_list(:user_tag, Flaredown.config.trackables_min_popularity, tag: popular_tag) }

    context 'index' do
      it 'allow to index personal tag' do
        is_expected.to be_able_to(:index, personal_tag)
      end
      it 'allow to index global tag' do
        is_expected.to be_able_to(:index, global_tag)
      end
      it 'don\'t allow to index another user\'s personal tag' do
        is_expected.not_to be_able_to(:index, another_user_tag)
      end
    end

    context 'show' do
      it 'allow to show global tags' do
        is_expected.to be_able_to(:show, global_tag)
      end
      it 'allow to show personal tag' do
        is_expected.to be_able_to(:show, personal_tag)
      end
      it "allow to show another user's personal tag" do
        is_expected.to be_able_to(:show, another_user_tag)
      end
    end

    context 'manage' do
      it "allow to manage user's personal tag" do
        is_expected.to be_able_to(:manage, personal_tag)
      end
      it "don't allow to manage another user's personal tag" do
        is_expected.not_to be_able_to(:manage, another_user_tag)
      end
    end

    context 'create' do
      let(:new_tag) { Tag.new(global: false) }
      let(:new_global_tag) { Tag.new }
      it 'allow to create non-global tag' do
        is_expected.to be_able_to(:create, new_tag)
      end
      it "don't allow to create global tag" do
        is_expected.not_to be_able_to(:create, new_global_tag)
      end
    end
  end
end
