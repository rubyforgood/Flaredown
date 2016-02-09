class Api::V1::SearchesController < Api::BaseController

  def show
    search = Search.new(search_params)

    if search.invalid?
      raise ActiveRecord::RecordInvalid.new(search)
    end

    render json: search
  end

  def search_params
    params.permit(:resource, query: [:name]).tap do |params|
      params[:user] = current_user
    end
  end
end
