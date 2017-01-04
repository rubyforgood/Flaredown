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

class Profile < ActiveRecord::Base
  enum pressure_units: %i(mb in)
  enum temperature_units: %i(f c)

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

  def age
    return if birth_date.nil?
    age = Date.today.year - birth_date.year
    Date.today < birth_date + age.years ? age-1 : age
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

  def set_most_recent_trackable_position(trackable, position)
    trackable_type = trackable.class.name.underscore
    self.send("set_most_recent_#{trackable_type}_position", trackable, position)
  end

  def most_recent_trackable_position_for(trackable)
    trackable_type = trackable.class.name.underscore
    self.send("most_recent_#{trackable_type}_position_for", trackable)
  end

  %w(condition symptom treatment).each do |trackable_type|

    define_method "set_most_recent_#{trackable_type}_position" do |trackable, position|
      self.send(
        "most_recent_#{trackable_type.pluralize}_positions"
      )[trackable.id.to_s] = position.to_s
    end

    define_method "most_recent_#{trackable_type}_position_for" do |trackable|
      trackables_positions = self.send("most_recent_#{trackable_type.pluralize}_positions")
      if trackables_positions.blank?
        return nil
      else
        return trackables_positions[trackable.id.to_s].to_i
      end
    end

  end

end
