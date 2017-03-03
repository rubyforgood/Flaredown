class Api::V1::ChartListsController < ApplicationController
  def show
    render json: ChartListService.new(current_user: current_user).as_json
  end
end
