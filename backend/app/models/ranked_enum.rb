class RankedEnum
  include ActiveModel::Serialization

  attr_accessor :id, :rank

  def initialize(id, rank)
    @id = id
    @rank = rank
  end

  class << self
    def all_ids
      []
    end

    def find(id)
      all.find { |obj| obj.id.eql?(id) }
    end

    def all
      cache_key = "#{self.name.pluralize.underscore}"
      Rails.cache.fetch(cache_key) do
        result = []
        all_ids.each_with_index { |id, i| result << self.new(id, i + 1) }
        result
      end
    end
  end

  def name
    I18n.t "#{key}.#{id}"
  end

  def key
    self.class.name.underscore
  end

end
