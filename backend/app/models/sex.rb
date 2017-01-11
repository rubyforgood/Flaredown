class Sex < RankedEnum
  class << self
    def all_ids
      %w(male female other doesnt_say)
    end
  end
end
