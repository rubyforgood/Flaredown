# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  authentication_token   :string           not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe User do
  describe 'Associations' do
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_many(:conditions).through(:user_conditions) }
    it { is_expected.to have_many(:symptoms).through(:user_symptoms) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'Callbacks' do
    subject { create(:user) }
    context 'before_create' do
      it 'generates authentication token' do
        expect(subject.reload.authentication_token).to be_present
      end
    end
    context 'after_create' do
      it 'creates profile' do
        profile = subject.reload.profile
        expect(profile).to be_present
        expect(profile.id).to be_present
        expect(profile.user.id).to eq subject.id
        expect(profile.onboarding_step_id).to eq Step.by_group(:onboarding).first.id
      end
    end
  end
end
