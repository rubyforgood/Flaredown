require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context 'for symptoms' do
    let!(:global_symptom) { create(:symptom) }
    let!(:personal_symptom) { create(:user_symptom, user: user).symptom }
    let!(:another_user_symptom) { create(:user_symptom).symptom }
    let!(:popular_symptom) { create(:symptom, :personal) }
    before { create_list(:user_symptom, Flaredown.config.trackables_min_popularity, symptom: popular_symptom) }

    context 'index' do
      it 'allow to index personal symptom' do
        is_expected.to be_able_to(:index, personal_symptom)
      end

      it 'allow to index global symptoms' do
        is_expected.to be_able_to(:index, global_symptom)
      end

      it 'don\'t allow to index another user\'s personal symptom' do
        is_expected.not_to be_able_to(:index, another_user_symptom)
      end
    end

    context 'show' do
      it 'allow to show global symptoms' do
        is_expected.to be_able_to(:show, global_symptom)
      end
      it 'allow to show personal symptoms' do
        is_expected.to be_able_to(:show, personal_symptom)
      end
      it "allow to show popular symptoms" do
        is_expected.to be_able_to(:show, popular_symptom)
      end
      it "allow to show another user's personal symptoms" do
        is_expected.to be_able_to(:show, another_user_symptom)
      end
    end

    context 'manage' do
      it "allow to manage user's personal symptoms" do
        is_expected.to be_able_to(:manage, personal_symptom)
      end
      it "don't allow to manage another user's personal symptoms" do
        is_expected.not_to be_able_to(:manage, another_user_symptom)
      end
    end

    context 'create' do
      let(:new_symptom) { Symptom.new(global: false) }
      let(:new_global_symptom) { Symptom.new }
      it 'allow to create non-global symptoms' do
        is_expected.to be_able_to(:create, new_symptom)
      end
      it "don't allow to create global symptoms" do
        is_expected.not_to be_able_to(:create, new_global_symptom)
      end
    end

    context 'popular symptoms' do
      before { create_list(:user_symptom, Flaredown.config.trackables_min_popularity, symptom: global_symptom) }
      let(:popular_symptom_ids) { Ability.new(user).send('popular_trackable_ids', 'Symptom') }

      it { expect(popular_symptom_ids).to eq([global_symptom.id]) }
    end
  end
end
