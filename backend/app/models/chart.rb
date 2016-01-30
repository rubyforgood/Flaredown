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

  def series
    [
      {
        type: 'line',
        color: '#8bcac4',
        name: "Crohn's Disease 1",
        data: (start_at..end_at).map { |day| { x: day, y:  random_value} }
      },
      {
        type: 'line',
        color: '#ca77b4',
        name: "Crohn's Disease 2",
        data: (start_at..end_at).map { |day| { x: day, y: random_value } }
      },
      {
        type: 'line',
        color: '#fc8931',
        name: "Crohn's Disease 3",
        data: (start_at..end_at).map { |day| { x: day, y: random_value } }
      }
    ]
  end

  def random_value
    rand(1...5)
  end
end
