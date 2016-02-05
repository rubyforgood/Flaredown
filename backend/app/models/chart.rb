class Chart
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :id, :user, :start_at, :end_at, :filters

  CACHE_SIZE = 15

  #
  # Validations
  #
  validates :user, :start_at, :end_at, presence: true

  def timeline
    (start_at..end_at).map { |day| { x: day } }
  end

  def checkins
    @checkins ||= user.checkins.by_date(start_at.to_date - CACHE_SIZE, end_at.to_date + CACHE_SIZE)
  end

  def trackings
    user.trackings.active_at(Date.today)
  end

  def trackables
    trackings.map(&:trackable)
  end

end
