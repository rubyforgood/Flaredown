module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        # The aggregation reaches through `notificateable` to title each group, so without
        # eager loading this is one query per notification.
        notifications = Notification
          .where(encrypted_notify_user_id: current_user.encrypted_id)
          .includes(:notificateable)

        authorize_collection :index, notifications

        render json: {notifications: notifications.aggregated_by_kind_and_subject}
      end

      def update
        notifications = Notification.where(notification_params)

        authorize_collection :update, notifications

        if notifications.update_all(unread: false)
          render json: {notifications: notifications.aggregated_by_kind_and_subject}
        else
          render json: {errors: notifications.map(&:errors).compact}, status: :unprocessable_entity
        end
      end

      def destroy
        notifications = Notification.where(notification_params)

        authorize_collection :destroy, notifications

        if notifications.destroy
          head :no_content
        else
          render json: {errors: notifications.map(&:errors).compact}, status: :unprocessable_entity
        end
      end

      private

      def notification_params
        parameters = params.permit(:notificateable_id, :notificateable_type)

        parameters[:notificateable_type] = parameters[:notificateable_type].titleize
        parameters[:encrypted_notify_user_id] = current_user.encrypted_id

        # Mongoid 9 requires a query expression to be a Hash and raises InvalidQuery on
        # an ActionController::Parameters, which Mongoid 8 accepted.
        parameters.to_h
      end

      def authorize_collection(name, collection)
        collection.each { |element| authorize! name, element }
      end
    end
  end
end
