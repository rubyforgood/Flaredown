# == Schema Information
#
# Table name: profiles
#
#  id                               :integer          not null, primary key
#  user_id                          :integer
#  country_id                       :string
#  birth_date                       :date
#  sex_id                           :string
#  onboarding_step_id               :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  ethnicity_ids_string             :string
#  day_habit_id                     :string
#  education_level_id               :string
#  day_walking_hours                :integer
#  most_recent_doses                :hstore
#  screen_name                      :string
#  most_recent_conditions_positions :hstore
#  most_recent_symptoms_positions   :hstore
#  most_recent_treatments_positions :hstore
#

require "rails_helper"

RSpec.describe Profile do
  describe "Associations" do
    it { is_expected.to belong_to(:user) }
  end
  describe "Validations" do
    it { is_expected.to validate_inclusion_of(:country_id).in_array(Country.codes) }
    it { is_expected.to validate_inclusion_of(:sex_id).in_array(Sex.all_ids) }
  end
  describe "Respond to" do
    it { is_expected.to respond_to(:birth_date) }
    context "most recent trackables positions" do
      it { is_expected.to respond_to(:set_most_recent_trackable_position).with(2).arguments }
      it { is_expected.to respond_to(:most_recent_trackable_position_for).with(1).argument }
      it { is_expected.to respond_to(:set_most_recent_condition_position).with(2).arguments }
      it { is_expected.to respond_to(:most_recent_condition_position_for).with(1).argument }
      it { is_expected.to respond_to(:set_most_recent_symptom_position).with(2).arguments }
      it { is_expected.to respond_to(:most_recent_symptom_position_for).with(1).argument }
      it { is_expected.to respond_to(:set_most_recent_treatment_position).with(2).arguments }
      it { is_expected.to respond_to(:most_recent_treatment_position_for).with(1).argument }
    end
  end
  describe "ethnicities" do
    context "get" do
      before { subject.ethnicity_ids_string = "latino,white" }
      it "transforms to array" do
        expect(subject.ethnicity_ids).to eq %w[latino white]
      end
    end
    context "set" do
      before { subject.ethnicity_ids = %w[latino white] }
      it "transforms to string" do
        expect(subject.ethnicity_ids_string).to eq "latino,white"
      end
    end
  end
end
