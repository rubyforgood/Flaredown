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
#

class Profile < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :user

  #
  # Validations
  #

  validates :country_id, inclusion: {
    in: Country.codes,
    message: '%{value} is not a valid country_id'
  }, if: 'country_id.present?'

  validates :sex_id, inclusion: {
    in: Sex.all_ids,
    message: '%{value} is not a valid sex_id'
  }, if: 'sex_id.present?'

  validates :day_habit_id, inclusion: {
    in: DayHabit.all_ids,
    message: '%{value} is not a valid day_habit_id'
  }, if: 'day_habit_id.present?'

  validates :education_level_id, inclusion: {
    in: EducationLevel.all_ids,
    message: '%{value} is not a valid education_level_id'
  }, if: 'education_level_id.present?'

  validate :ethnicity_ids_are_valid, if: 'ethnicity_ids_string.present?'
  def ethnicity_ids_are_valid
    ethnicity_ids.each do |id|
      unless Ethnicity.all_ids.include?(id)
        errors.add(:ethnicity_ids, "#{id} is not a valid ethnicity_id")
        break
      end
    end
  end

  #
  # Instance Methods
  #

  def country
    @country ||= Country.find_country_by_alpha2(country_id) if country_id.present?
  end

  def locale
    country.languages.first if country.present?
  end

  def ethnicity_ids
    ethnicity_ids_string.split(',') rescue []
  end
  def ethnicity_ids=(ids)
    self.ethnicity_ids_string = ids.join(',')
  end

  def set_most_recent_dose(treatment_id, dose)
    self.most_recent_doses[treatment_id.to_s] = dose
  end

  def most_recent_dose_for(treatment_id)
    self.most_recent_doses[treatment_id.to_s]
  end

end
