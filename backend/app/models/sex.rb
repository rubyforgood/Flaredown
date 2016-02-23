class Sex
  include ActiveModel::Serialization

  attr_accessor :id, :rank

  def initialize(id, rank)
    @id = id
    @rank = rank
  end

  ALL_IDS =  %w( male female other doesnt_say )

  class << self

    def find(id)
      Store.instance.all.find { |sex| sex.id.eql?(id) }
    end

    def all_ids
      ALL_IDS
    end

    def all
      Store.instance.all
    end

  end

  class Store
    include Singleton
    attr_reader :all

    def initialize
      @all = []
      ALL_IDS.each_with_index { |id, i| @all << Sex.new(id, i + 1) }
      @all
    end
  end

end
