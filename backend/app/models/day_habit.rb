class DayHabit < RankedEnum
  class << self
    def all_ids
      %w( lying_down sitting_down on_feet driving working_with_hands )
    end
  end

  def name
    I18n.t "#{key}.#{id}.name"
  end

  def description
    I18n.t "#{key}.#{id}.description"
  end

end
