class Api::V1::DayHabitsController < ApplicationController
  skip_before_action :authenticate_user!

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
    # FIXME
    # rubocop:disable Style/SignalException
    fail(ActionController::BadRequest, 'id param is not a valid day_habit id') unless DayHabit.all_ids.include?(id)
    # rubocop:enable Style/SignalException
    id
  end
end
