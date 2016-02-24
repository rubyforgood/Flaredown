class DayHabitSerializer < RankedEnumSerializer
  attributes :description

  def name
    I18n.t "#{key}.#{object.id}.name"
  end

  def description
    I18n.t "#{key}.#{object.id}.description"
  end

end
