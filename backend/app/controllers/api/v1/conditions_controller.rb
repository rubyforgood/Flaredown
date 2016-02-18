class Api::V1::ConditionsController < Api::BaseController
  load_and_authorize_resource

  def index
    @conditions = @conditions.where(id: ids) if ids.present?
    render json: @conditions
  end

  def show
    render json: @condition
  end

  def create
    UserCondition.create!(user: current_user, condition: @condition)
    render json: @condition.reload
  end

  private

  def create_params
    params.require(:condition).permit(:name)
  end

  def ids
    @ids ||= params[:ids]
  end
end
