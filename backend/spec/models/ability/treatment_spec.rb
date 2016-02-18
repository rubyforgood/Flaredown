require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject { Ability.new(user) }

  context 'for treatments' do
    let!(:global_treatment) { create(:treatment) }
    let!(:personal_treatment) { create(:user_treatment, user: user).treatment }
    let!(:another_user_treatment) { create(:user_treatment).treatment }

    context 'read' do
      it 'allow to read global treatments' do
        is_expected.to be_able_to(:read, global_treatment)
      end
      it 'allow to read personal treatments' do
        is_expected.to be_able_to(:read, personal_treatment)
      end
      it "don't allow to read another user's personal treatments" do
        is_expected.not_to be_able_to(:read, another_user_treatment)
      end
    end

    context 'manage' do
      it "allow to manage user's personal treatments" do
        is_expected.to be_able_to(:manage, personal_treatment)
      end
      it "don't allow to manage another user's personal treatments" do
        is_expected.not_to be_able_to(:manage, another_user_treatment)
      end
    end

    context 'create' do
      let(:new_treatment) { Treatment.new(global: false) }
      let(:new_global_treatment) { Treatment.new }
      it 'allow to create non-global treatments' do
        is_expected.to be_able_to(:create, new_treatment)
      end
      it "don't allow to create global treatments" do
        is_expected.not_to be_able_to(:create, new_global_treatment)
      end
    end
  end
end
