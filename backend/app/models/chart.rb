class Chart
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :id, :user, :start_at, :end_at, :filters

  #
  # Validations
  #
  validates :user, :start_at, :end_at, presence: true

  def timeline
    (start_at..end_at).map { |day| { x: day } }
  end

  def checkins
    @checkins ||= user.checkins.by_date(start_at, end_at)
  end

  def cached_checkins
    @cached_checkins ||= begin
      user.checkins.by_date(start_at.to_date - 15, start_at.to_date - 1) +
      user.checkins.by_date(end_at.to_date + 1, end_at.to_date + 15)
    end
  end

  def trackings
    user.trackings.active_at(Date.today)
  end

  def trackables
    trackings.map(&:trackable)
  end

end
