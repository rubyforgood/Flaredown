# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  trackable_id   :integer
#  trackable_type :string
#  start_at       :datetime
#  end_at         :datetime
#

class TrackingSerializer < ApplicationSerializer
  attributes :id, :user_id, :trackable_id, :trackable_type, :start_at, :end_at
end
