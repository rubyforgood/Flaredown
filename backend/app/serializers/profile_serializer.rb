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

class ProfileSerializer < ApplicationSerializer
  attributes :id, :screen_name, :birth_date, :country_id, :sex_id, :onboarding_step_id,
             :ethnicity_ids, :day_habit_id, :education_level_id, :day_walking_hours,
             :pressure_units, :temperature_units, :beta_tester, :notify_token, :notify, :checkin_reminder,
             :checkin_reminder_at

  def checkin_reminder_at
    checkin_reminder_at = object.checkin_reminder_at
    time = checkin_reminder_at.blank? ? [20, 0] : checkin_reminder_at.strftime('%H:%M').split(':')

    { hours: time[0], minutes: time[1] }
  end
end
