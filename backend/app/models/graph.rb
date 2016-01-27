class Graph
  include ActiveModel::Serialization

  attr_accessor :id, :user, :filters

  def initialize(id, user, filters = {})
    @id, @user, @filters = id, user, filters
  end

  def series
    { columns: columns }
  end

  def axis
    nil
  end

  private

  def columns
    [
      ['data1', 30, 200, 100, 400, 150, 250],
      ['data2', 130, 340, 200, 500, 250, 350]
    ]
  end

end
