class Search::ForTopic < ::Search
  alias super_query find_by_query

  protected

  def find_by_query
    (foods + tags + symptoms + conditions + treatments).sort_by(&:name)
  end

  private

  %w(tag symptom condition treatment).each do |trackable|
    define_method trackable.pluralize do
      @resource = trackable

      super_query
    end
  end

  def foods
    if query_hash.present?
      Food.fts(query[:name], MAX_ROWS)
    elsif scope == 'random'
      Food.limit(MAX_ROWS).order('RANDOM()')
    else
      Food.limit(MAX_ROWS)
    end.to_a
  end
end
