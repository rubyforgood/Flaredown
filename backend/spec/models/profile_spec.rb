# == Schema Information
#
# Table name: profiles
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  country_id           :string
#  birth_date           :date
#  sex_id               :string
#  onboarding_step_id   :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ethnicity_ids_string :string
#  day_habit_id         :string
#  education_level_id   :string
#  day_walking_hours    :integer
#  most_recent_doses    :hstore
#  screen_name          :string
#

require 'rails_helper'

RSpec.describe Profile do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end
  describe 'Validations' do
    it { is_expected.to validate_inclusion_of(:country_id).in_array(Country.codes) }
    it { is_expected.to validate_inclusion_of(:sex_id).in_array(Sex.all_ids) }
  end
  describe 'Respond to' do
    it { is_expected.to respond_to(:birth_date) }
  end
  describe 'ethnicities' do
    context 'get' do
      before { subject.ethnicity_ids_string='latino,white' }
      it 'transforms to array' do
        expect(subject.ethnicity_ids).to eq ['latino','white']
      end
    end
    context 'set' do
      before { subject.ethnicity_ids=['latino','white'] }
      it 'transforms to string' do
        expect(subject.ethnicity_ids_string).to eq 'latino,white'
      end
    end
  end
end
