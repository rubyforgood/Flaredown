class Search::ForTopic < ::Search
  alias super_query find_by_query

  protected

  def find_by_query
    (tags + symptoms + conditions + treatments).sort { |a, b| a.name.underscore <=> b.name.underscore }
  end

  private

  %w(tag symptom condition treatment).each do |trackable|
    define_method trackable.pluralize do
      @resource = trackable

      super_query
    end
  end
end
