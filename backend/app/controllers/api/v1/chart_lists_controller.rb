module Api
  module V1
    class ChartListsController < ApplicationController
      def show
        render json: ChartListService.new(current_user: current_user).as_json
      end
    end
  end
end
