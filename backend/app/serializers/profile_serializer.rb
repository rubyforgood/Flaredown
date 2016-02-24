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
#

class ProfileSerializer < ApplicationSerializer
  attributes :id, :birth_date, :country_id, :sex_id, :onboarding_step_id,
             :ethnicity_ids, :day_habit_id, :education_level_id, :day_walking_hours

end
