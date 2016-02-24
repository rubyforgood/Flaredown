class Api::V1::DayHabitsController < Api::BaseController
  def index
    render json: DayHabit.all
  end

  def show
    day_habit = DayHabit.find(day_habit_id)
    render json: day_habit
  end

  private

  def day_habit_id
    id = params.require(:id)
    fail ActionController::BadRequest.new('id param is not a valid day_habit id') unless DayHabit.all_ids.include?(id)
    id
  end
end
