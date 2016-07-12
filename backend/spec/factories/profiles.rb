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

FactoryGirl.define do
  factory :profile do
    birth_date { (25..55).to_a.sample.years.ago }
    country_id FFaker::Address.country_code
    sex_id Sex.all_ids.sample
  end
end
