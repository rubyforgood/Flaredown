# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  start_at       :date
#  end_at         :date
#

class Tracking < ActiveRecord::Base

  #
  # Associations
  #
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  #
  # Validations
  #
  validates :user, :trackable, :start_at, presence: true

  #
  # Scopes
  #
  scope :active_at, ->(at) { where("start_at <= :at AND (end_at > :at OR end_at IS NULL)", at: at.strftime('%F')) }

end
