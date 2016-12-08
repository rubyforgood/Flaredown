class Search::ForFood < ::Search
  validates :query, presence: true

  protected

  def find_by_query
    resources
      .where(
        'long_desc ILIKE :name OR shrt_desc ILIKE :name OR comname ILIKE :name OR sciname ILIKE :name',
        { name: "%#{query[:name]}%" }
      )
      .limit(MAX_ROWS)
  end
end
