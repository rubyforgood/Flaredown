# == Schema Information
#
# Table name: trackable_usages
#
#  id             :integer          not null, primary key
#  count          :integer          default(1)
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trackable_id   :integer
#  user_id        :integer
#
# Indexes
#
#  index_trackable_usages_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_trackable_usages_on_unique_columns                   (user_id,trackable_type,trackable_id) UNIQUE
#  index_trackable_usages_on_user_id                          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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
  validates :count, numericality: {greater_than: 0}

  #
  # Callbacks
  #
  after_commit ->(obj) { SwitchTrackableVisibility.perform_later(obj.id) }
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
