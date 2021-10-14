module Api
  module V1
    class ConditionsController < ApplicationController
      load_and_authorize_resource
      skip_before_action :authenticate_user!, only: [:show]

      def index
        @conditions = @conditions.includes(:translations)
        @conditions = ids.present? ? @conditions.where(id: ids) : @conditions.order(:name).limit(50)

        render json: @conditions
      end

      def show
        render json: @condition
      end

      def create
        render json: TrackableCreator.new(@condition, current_user).create!
      end

      private

      def create_params
        params.require(:condition).permit(:name)
      end

      def ids
        @ids ||= params[:ids] if params[:ids].is_a?(Array)
      end
    end
  end
end
