class TrackingDestroyer
  attr_reader :user, :tracking, :date

  def initialize(user, tracking, date)
    @user = user
    @tracking = tracking
    @date = date
  end

  def destroy
    # If a tracking for the same trackable started at the same date is found,
    # then it can be destroyed because we're in the case of an unwanted action
    sameTracking = user.trackings.find_by(
      trackable_id: tracking.trackable_id,
      trackable_type: tracking.trackable_type,
      start_at: date
    )
    if sameTracking.present?
      tracking.destroy
    else
      tracking.update_attributes!(end_at: Date.today)
    end
  end
end
