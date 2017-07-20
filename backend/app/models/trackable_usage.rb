# == Schema Information
#
# Table name: trackable_usages
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  count          :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TrackableUsage < ActiveRecord::Base

  #
  # Associations
  #

  belongs_to :user
  belongs_to :trackable, polymorphic: true, counter_cache: true

  #
  # Validations
  #
  validates :count, numericality: { greater_than: 0 }

  #
  # Callbacks
  #

  after_commit -> (obj) { SwitchTrackableVisibility.perform_later(obj.id) }
  #
  # Class Methods
  #

  class << self

    def create_or_update_by(user: nil, trackable: nil)
      trackable_usage = find_by(user: user, trackable: trackable)
      if trackable_usage.present?
        trackable_usage.increment! :count
        trackable_usage
      else
        create!(user: user, trackable: trackable)
      end
    end

  end

end
