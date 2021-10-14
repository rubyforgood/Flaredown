module Api
  module V1
    class PostablesController < ApplicationController
      load_and_authorize_resource

      def index
        render json: PostableSerializer.new(
          @postables
            .where(encrypted_user_id: current_user.encrypted_id)
            .order_by(created_at: :desc)
            .page(params[:page])
            .per(20),
          current_user
        )
      end
    end
  end
end
