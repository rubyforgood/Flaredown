class Api::V1::GraphsController < Api::BaseController

  def show
    graph = Graph.new(graph_params)

    if graph.invalid?
      raise ActiveRecord::RecordInvalid(graph)
    end

    render json: graph
  end

  def graph_params
    params.permit(:id, :filters).tap do |params|
      params[:user] = current_user
    end
  end
end
