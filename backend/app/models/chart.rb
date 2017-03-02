class Chart
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :id, :user, :start_at, :end_at, :includes

  #
  # Validations
  #
  validates :user, :start_at, :end_at, presence: true

  def checkins
    @checkins ||= user.checkins.by_date(start_at.to_date, end_at.to_date).map do |checkin|
      checkin.includes = includes

      checkin
    end
  end

  def trackables
    @_trackables ||= trackings.map(&:trackable)
  end

  private

  def trackings
    return Tracking.none if includes.blank?

    relation = Tracking.includes(:trackable)

    relation
      .where(trackable_type: :Condition, trackable_id: includes[:conditions] || [])
      .or(relation.where(trackable_type: :Symptom, trackable_id: includes[:symptoms] || []))
      .or(relation.where(trackable_type: :Treatment, trackable_id: includes[:treatments] || []))
      .where(user_id: user.id)
      .active_in_range(start_at.to_date, end_at.to_date)
  end
end
