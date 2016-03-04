require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context 'for conditions' do
    let!(:global_condition) { create(:condition) }
    let!(:personal_condition) { create(:user_condition, user: user).condition }
    let!(:another_user_condition) { create(:user_condition).condition }
    let!(:popular_condition) { create(:condition, :personal) }
    before { create_list(:user_condition, Flaredown.config.trackables_min_popularity, condition: popular_condition) }

    context 'read' do
      it 'allow to read global conditions' do
        is_expected.to be_able_to(:read, global_condition)
      end
      it 'allow to read personal conditions' do
        is_expected.to be_able_to(:read, personal_condition)
      end
      it "allow to read popular conditions" do
        is_expected.to be_able_to(:read, popular_condition)
      end
      it "don't allow to read another user's personal conditions" do
        is_expected.not_to be_able_to(:read, another_user_condition)
      end
    end

    context 'manage' do
      it "allow to manage user's personal conditions" do
        is_expected.to be_able_to(:manage, personal_condition)
      end
      it "don't allow to manage another user's personal conditions" do
        is_expected.not_to be_able_to(:manage, another_user_condition)
      end
    end

    context 'create' do
      let(:new_condition) { Condition.new(global: false) }
      let(:new_global_condition) { Condition.new }
      it 'allow to create non-global conditions' do
        is_expected.to be_able_to(:create, new_condition)
      end
      it "don't allow to create global conditions" do
        is_expected.not_to be_able_to(:create, new_global_condition)
      end
    end
  end
end
