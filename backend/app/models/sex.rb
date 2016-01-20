class Sex
  include ActiveModel::Serialization

  attr_accessor :id

  def initialize(id)
    @id = id
  end

  class << self
    def all_ids
      %w( male female other doesnt_say )
    end

    def all
      all_ids.map { |id| new(id) }
    end
  end

end
