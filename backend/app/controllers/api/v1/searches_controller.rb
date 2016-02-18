class Api::V1::SearchesController < Api::BaseController
  def show
    search = Search.new(search_params)

    fail ActiveRecord::RecordInvalid.new(search) if search.invalid?

    render json: search
  end

  def search_params
    params.permit(:resource, query: [:name]).tap do |params|
      params[:user] = current_user
    end
  end
end
