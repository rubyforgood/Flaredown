# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  authentication_token   :string           not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  include Authenticatable

  #
  # Associations
  #

  has_one :profile, dependent: :destroy

  has_many :user_conditions, dependent: :destroy
  has_many :conditions, through: :user_conditions

  has_many :user_symptoms, dependent: :destroy
  has_many :symptoms, through: :user_symptoms

  has_many :user_treatments, dependent: :destroy
  has_many :treatments, through: :user_treatments

  has_many :trackings, dependent: :destroy

  #
  # Validations
  #
  validates :email, presence: true

  #
  # Callbacks
  #
  before_create :generate_authentication_token
  after_create :init_profile

  #
  # Delegates
  #
  delegate :locale, to: :profile

  def checkins
    Checkin.where(user_id: id)
  end

  def notification_channel
    "private-#{id}"
  end

  def push(event, message)
    Flaredown.pusher.push(notification_channel, event, message)
  end

  private

  def generate_authentication_token
    self.authentication_token = loop do
      random_token = SecureRandom.hex
      break random_token unless User.exists?(authentication_token: random_token)
    end
  end

  def init_profile
    create_profile!(onboarding_step_id: Step.by_group(:onboarding).first.id)
  end
end
