class Api::V1::SearchesController < ApplicationController
  SEARCH_MAPPER = {
    'dose' => Search::ForDose,
    'food' => Search::ForFood
  }

  def show
    search = (SEARCH_MAPPER[resource_param] || Search).new(search_params)

    fail ActiveRecord::RecordInvalid.new(search) if search.invalid?

    render json: search, serializer: SearchSerializer
  end

  def search_params
    params.permit(:resource, :scope, query: [:name, :treatment_id]).tap do |params|
      params[:user] = current_user
    end
  end

  def resource_param
    params[:resource]
  end
end
