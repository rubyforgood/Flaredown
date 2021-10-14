module Api
  module V1
    class UnsubscribesController < ApplicationController
      skip_before_action :authenticate_user!

      def update
        @profile = Profile.find_by(notify_token: activation_params[:notify_token])
        @profile&.update_column(attribute_dispatcher_key, false)

        render json: @profile
      end

      private

      def activation_params
        params.permit(:notify_token, :notify_top_posts, :stop_remind)
      end

      def attribute_dispatcher_key
        if activation_params[:stop_remind]
          :checkin_reminder
        elsif activation_params[:notify_top_posts]
          :notify_top_posts
        else
          :notify
        end
      end
    end
  end
end
