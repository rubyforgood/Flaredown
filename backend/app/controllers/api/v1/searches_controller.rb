module Api
  module V1
    class SearchesController < ApplicationController
      SEARCH_MAPPER = {
        "dose" => Search::ForDose,
        "food" => Search::ForFood,
        "topic" => Search::ForTopic
      }.freeze

      skip_before_action :authenticate_user!, only: :show

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
  end
end
