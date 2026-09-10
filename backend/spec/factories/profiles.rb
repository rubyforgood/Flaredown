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

FactoryBot.define do
  factory :profile do
    birth_date { (25..55).to_a.sample.years.ago }
    country_id { FFaker::Address.country_code }
    sex_id { Sex.all_ids.sample }
  end
end
