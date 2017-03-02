class Api::V1::ChartListsController < ApplicationController
  def show
    render json: ChartListService.as_json(current_user: current_user)
  end
end
