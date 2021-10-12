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
      Rails.cache.fetch(name.pluralize.underscore) do
        result = []
        all_ids.each_with_index { |id, i| result << new(id, i + 1) }
        result
      end
    end
  end

  def name
    I18n.t! "#{key}.#{id}"
  rescue I18n::MissingTranslationData
    # This avoids strings in the UI like "translation missing: pt.sex.male"
    I18n.t "#{key}.#{id}", locale: :en
  end

  def key
    self.class.name.underscore
  end
end
