require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability do
  let!(:user) { create(:user) }

  subject() { Ability.new(user) }

  context 'for symptoms' do
    let!(:global_symptom) { create(:symptom) }
    let!(:personal_symptom) { create(:user_symptom, user: user).symptom }
    let!(:another_user_symptom) { create(:user_symptom).symptom }

    context 'read' do
      it 'allow to read global symptoms' do
        is_expected.to be_able_to(:read, global_symptom)
      end
      it 'allow to read personal symptoms' do
        is_expected.to be_able_to(:read, personal_symptom)
      end
      it "don't allow to read another user's personal symptoms" do
        is_expected.not_to be_able_to(:read, another_user_symptom)
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
      it "allow to create non-global symptoms" do
        is_expected.to be_able_to(:create, new_symptom)
      end
      it "don't allow to create global symptoms" do
        is_expected.not_to be_able_to(:create, new_global_symptom)
      end
    end
  end

end
