class Chart
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :id, :user, :start_at, :end_at, :filters

  #
  # Validations
  #
  validates :user, :start_at, :end_at, presence: true

  def checkins
    @checkins ||= user.checkins.by_date(start_at.to_date, end_at.to_date)
  end

  def trackables
    trackings.map(&:trackable)
  end

  private

  def trackings
    user.trackings.active_at(end_at.to_date)
  end
end
