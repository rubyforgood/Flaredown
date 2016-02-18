class Sex
  include ActiveModel::Serialization

  attr_accessor :id, :rank

  def initialize(id, rank)
    @id = id
    @rank = rank
  end

  class << self
    def all_ids
      %w( male female other doesnt_say )
    end

    def all
      @@all ||= begin
        result = []
        all_ids.each_with_index { |id, i| result << new(id, i + 1) }
        result
      end
    end

    def find(id)
      all.find { |sex| sex.id.eql?(id) }
    end
  end
end
