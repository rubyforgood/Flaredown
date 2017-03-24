class Api::V1::SearchesController < ApplicationController
  SEARCH_MAPPER = {
    'dose' => Search::ForDose,
    'food' => Search::ForFood,
    'topic' => Search::ForTopic
  }.freeze

  def show
    search = (SEARCH_MAPPER[resource_param] || Search).new(search_params)

    # FIXME
    # rubocop:disable Style/SignalException
    fail(ActiveRecord::RecordInvalid, search) if search.invalid?
    # rubocop:enable Style/SignalException

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
