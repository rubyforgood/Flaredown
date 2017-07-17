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
             :checkin_reminder_at, :time_zone_name, :notify_top_posts

  def checkin_reminder_at
    { hours: serialized_time[0], minutes: serialized_time[1] }
  end

  def time_zone_name
    time_zone_name = object.time_zone_name

    return Profile::TIMEZONE_PARAMS[:time_zone_name] if time_zone_name.nil? || time_zone_name&.empty?
    time_zone_name
  end

  def serialized_time
    reminder_at = object.checkin_reminder_at

    reminder_at.blank? ? Profile::TIMEZONE_PARAMS[:time] : reminder_at.strftime('%H:%M').split(':')
  end
end
