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
#  authentication_token   :string           default(""), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  username               :string           not null
#  bio                    :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  include Authenticatable

  #
  # Validations
  #
  validates :first_name, presence: true
  validates :last_name,  presence: true

  validates :username, presence: true
  validates :username, uniqueness: true, allow_blank: false
  validates :username, length: { in: 3..15 }, allow_blank: false

  #
  # Callbacks
  #
  before_create :generate_authentication_token

  def invitation
    @invitation ||= Invitation.new(self)
  end

  private

  def generate_authentication_token
    self.authentication_token = loop do
      random_token = SecureRandom.hex
      break random_token unless User.exists?(authentication_token: random_token)
    end
  end

end
