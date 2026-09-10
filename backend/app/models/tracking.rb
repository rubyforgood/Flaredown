# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  end_at         :date
#  start_at       :date
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  color_id       :integer
#  trackable_id   :integer
#  user_id        :integer
#
# Indexes
#
#  index_trackings_on_trackable_type                   (trackable_type)
#  index_trackings_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_trackings_on_user_id                          (user_id)
#  index_trackings_unique_trackable                    (user_id,trackable_id,trackable_type,start_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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

  TYPES = %w[Condition Symptom Treatment].freeze

  validates :user, :trackable, :start_at, presence: true

  validates :trackable_type, inclusion: {
    in: TYPES
  }

  validates :user_id, uniqueness: {
    scope: %i[trackable_id trackable_type start_at], message: "is already tracking this trackable"
  }

  #
  # Scopes
  #
  scope :active_at, ->(at) { where("start_at <= :at AND (end_at >= :at OR end_at IS NULL)", at: at.strftime("%F")) }
  scope :by_trackable_type, ->(trackable_type) { where(trackable_type: trackable_type) }

  #
  # Callbacks
  #
  before_create :ensure_color_id

  def self.active_in_range(range_start, range_end)
    where(
      "(start_at <= :range_start OR start_at <= :range_end) AND (end_at > :range_start OR end_at IS NULL)",
      range_start: range_start.strftime("%F"),
      range_end: range_end.strftime("%F")
    )
  end

  def ensure_color_id
    return if color_id

    self.color_id = Flaredown::Colorable.color_id_for(trackable, user)
  end
end
