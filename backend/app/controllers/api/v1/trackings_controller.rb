module Api
  module V1
    class TrackingsController < ApplicationController
      load_and_authorize_resource except: :create

      def index
        render json: @trackings.by_trackable_type(trackable_type).active_at(at)
      end

      def show
        render json: @tracking
      end

      def create
        tracking = Tracking.new(create_params.merge(start_at: Time.zone.today, user: current_user))

        authorize! :create, tracking

        tracking.save!

        current_user.topic_following.add_topic("#{tracking.trackable_type.downcase}_ids", tracking.trackable_id)

        render json: tracking
      end

      def destroy
        TrackingDestroyer.new(current_user, @tracking, Time.zone.today).destroy
        head :no_content
      end

      private

      def at
        Time.zone.parse(params.require(:at))
      end

      def trackable_type
        params.require(:trackable_type)
      end

      def create_params
        params.require(:tracking).permit(:trackable_id, :trackable_type, :color_id)
      end
    end
  end
end
