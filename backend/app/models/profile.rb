# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  country_id :string
#  birth_date :date
#  sex_id     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
    message: "%{value} is not a valid country_id"
  }, if: 'country_id.present?'

  validates :sex_id, inclusion: {
    in: Sex.all_ids,
    message: "%{value} is not a valid sex_id"
  }, if: 'sex_id.present?'


  #
  # Instance Methods
  #

  def country
    @country ||= Country.find_country_by_alpha2(country_id) if country_id.present?
  end

  def locale
    country.languages.first if country.present?
  end

end
