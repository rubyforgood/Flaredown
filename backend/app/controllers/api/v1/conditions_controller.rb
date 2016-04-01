class Api::V1::ConditionsController < ApplicationController
  load_and_authorize_resource

  def index
    @conditions = @conditions.includes(:translations)
    if ids.present?
      @conditions = @conditions.where(id: ids)
    else
      @conditions = @conditions.order(:name).limit(50)
    end
    render json: @conditions
  end

  def show
    render json: @condition
  end

  def create
    render json: TrackableCreator.new(@condition, current_user).create!
  end

  private

  def create_params
    params.require(:condition).permit(:name)
  end

  def ids
    @ids ||= if params[:ids].is_a?(Array)
      params[:ids]
    end
  end
end
