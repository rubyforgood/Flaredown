class Api::V1::GraphsController < Api::BaseController

  def show
    render json: Graph.new(graph_params)
  end

  def graph_params
    params.permit(:id, :filters).tap do |params|
      params[:user] = current_user
    end
  end
end
