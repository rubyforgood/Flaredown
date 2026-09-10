# == Schema Information
#
# Table name: profiles
#
#  id                               :integer          not null, primary key
#  beta_tester                      :boolean          default(FALSE)
#  birth_date                       :date
#  checkin_reminder                 :boolean          default(FALSE)
#  checkin_reminder_at              :datetime
#  day_walking_hours                :integer
#  ethnicity_ids_string             :string
#  most_recent_conditions_positions :hstore
#  most_recent_doses                :hstore
#  most_recent_symptoms_positions   :hstore
#  most_recent_treatments_positions :hstore
#  notify                           :boolean          default(TRUE)
#  notify_token                     :string
#  notify_top_posts                 :boolean          default(TRUE)
#  pressure_units                   :integer          default(0)
#  rejected_type                    :string
#  screen_name                      :string
#  slug_name                        :string
#  temperature_units                :integer          default(0)
#  time_zone_name                   :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  country_id                       :string
#  day_habit_id                     :string
#  education_level_id               :string
#  onboarding_step_id               :string
#  reminder_job_id                  :string
#  sex_id                           :string
#  user_id                          :integer
#
# Indexes
#
#  index_profiles_on_slug_name  (slug_name)
#  index_profiles_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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
