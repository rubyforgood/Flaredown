class Graph
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :id, :user, :filters

  #
  # Validations
  #
  validates :user, presence: true

  def series
    {
      x: 'timeline',
      types: {
        data1: 'line',
        data2: 'spline'
      },
      columns: columns
    }
  end

  def axis
    {
      y: { show: false },
      x: {
        type: 'timeseries',
        tick: {
          format: '%Y-%m-%d'
        }
      }
    }
  end

  private

  def columns
    [
      ['timeline', '2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04', '2013-01-05', '2013-01-06'],
      ['data1', 30, 200, 100, 400, 150, 250],
      ['data2', 130, 340, 200, 500, 250, 350]
    ]
  end

end
