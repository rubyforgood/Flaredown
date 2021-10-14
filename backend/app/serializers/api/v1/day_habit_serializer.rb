module Api
  module V1
    class DayHabitSerializer < RankedEnumSerializer
      attributes :description
    end
  end
end
