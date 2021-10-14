module Api
  module V1
    class DiscoursesController < ApplicationController
      def create
        render json: {url: DiscourseClient.new(current_user, params).generate_url}
      end
    end
  end
end
