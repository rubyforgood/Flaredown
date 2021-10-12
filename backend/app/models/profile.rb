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
  enum pressure_units: %i[mb in]
  enum temperature_units: %i[f c]

  #
  # Associations
  #
  belongs_to :user

  delegate :email, to: :user

  MIN_AGE = 16

  #
  # Validations
  #

  validates :country_id, inclusion: {
    in: Country.codes
  }, if: -> { country_id.present? }

  validates :sex_id, inclusion: {
    in: Sex.all_ids
  }, if: -> { sex_id.present? }

  validates :day_habit_id, inclusion: {
    in: DayHabit.all_ids,
    message: "%{value} is not a valid day_habit_id"
  }, if: -> { day_habit_id.present? }

  validates :education_level_id, inclusion: {
    in: EducationLevel.all_ids,
    message: "%{value} is not a valid education_level_id"
  }, if: -> { education_level_id.present? }

  validate :ethnicity_ids_are_valid, if: -> { ethnicity_ids_string.present? }
  validate :age_of_birth, if: -> { birth_date.present? }

  def ethnicity_ids_are_valid
    ethnicity_ids.each do |id|
      unless Ethnicity.all_ids.include?(id)
        errors.add(:ethnicity_ids, "#{id} is not a valid ethnicity_id")
        break
      end
    end
  end

  #
  # Callbacks
  #
  before_create :generate_notify_token
  before_save :ensure_slug_name, if: :screen_name_changed?

  TIMEZONE_PARAMS = {
    time: [20, 0],
    time_zone_name: "America/New_York"
  }.freeze

  NOTIFICATION_ATTRS = %w[checkin_reminder notify_top_posts notify].freeze

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

    today = Time.zone.today
    age = today.year - birth_date.year

    today < birth_date + age.years ? age - 1 : age
  end

  def ethnicity_ids
    ethnicity_ids_string&.split(",") || []
  end

  def ethnicity_ids=(ids)
    self.ethnicity_ids_string = ids.join(",")
  end

  def set_most_recent_dose(treatment_id, dose)
    most_recent_doses[treatment_id.to_s] = dose
  end

  def most_recent_dose_for(treatment_id)
    most_recent_doses[treatment_id.to_s]
  end

  def set_most_recent_trackable_position(trackable, position)
    trackable_type = trackable.class.name.underscore
    send("set_most_recent_#{trackable_type}_position", trackable, position)
  end

  def most_recent_trackable_position_for(trackable)
    trackable_type = trackable.class.name.underscore
    send("most_recent_#{trackable_type}_position_for", trackable)
  end

  %w[condition symptom treatment].each do |trackable_type|
    define_method "set_most_recent_#{trackable_type}_position" do |trackable, position|
      send(
        "most_recent_#{trackable_type.pluralize}_positions"
      )[trackable.id.to_s] = position.to_s
    end

    define_method "most_recent_#{trackable_type}_position_for" do |trackable|
      trackables_positions = send("most_recent_#{trackable_type.pluralize}_positions")

      return nil if trackables_positions.blank?

      trackables_positions[trackable.id.to_s].to_i
    end
  end

  private

  def generate_notify_token
    self.notify_token =
      loop do
        random_token = SecureRandom.hex
        break random_token unless Profile.exists?(notify_token: random_token)
      end
  end

  def ensure_slug_name
    slug_name = screen_name && screen_name.split(/\s/).map(&:capitalize).join("")
    assign_attributes(slug_name: slug_name)
  end

  def age_of_birth
    if age < MIN_AGE
      errors.add(:birth_date, "You must be #{MIN_AGE} years or older to use this app according
      to international privacy regulations. Sorry :(")
    end
  end
end
