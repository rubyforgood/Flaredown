module Api
  module V1
    class EthnicitiesController < ApplicationController
      skip_before_action :authenticate_user!

      def index
        render json: Ethnicity.all
      end

      def show
        ethnicity = Ethnicity.find(ethnicity_id)
        render json: ethnicity
      end

      private

      def ethnicity_id
        id = params.require(:id)
        # FIXME
        # rubocop:disable Style/SignalException
        fail(ActionController::BadRequest, "id param is not a valid ethnicity id") unless Ethnicity.all_ids.include?(id)
        # rubocop:enable Style/SignalException
        id
      end
    end
  end
end
