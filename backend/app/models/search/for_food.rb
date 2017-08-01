class Search::ForFood < ::Search
  validates :query, presence: true

  protected

  def find_by_query
    Food.fts(query[:name], MAX_ROWS, user.id)
  end
end
