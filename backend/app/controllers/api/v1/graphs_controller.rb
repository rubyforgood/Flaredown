class Api::V1::GraphsController < Api::BaseController

  def show
    render json: Graph.new(params[:id], current_user, params[:filters])
  end

end
