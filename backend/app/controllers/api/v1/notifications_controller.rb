class Api::V1::NotificationsController < ApplicationController
  def index
    notifications = Notification.where(encrypted_notify_user_id: current_user.encrypted_id)

    authorize_collection :index, notifications

    render json: { notifications: notifications.aggregated_by_kind_and_subject }
  end

  def destroy
    notifications = Notification.where(notification_params)

    authorize_collection :destroy, notifications

    if notifications.destroy
      head :no_content
    else
      render json: { errors: notifications.map(&:errors).compact }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    parameters = params.permit(:notificateable_id, :notificateable_type)

    parameters[:notificateable_type] = parameters[:notificateable_type].titleize
    parameters[:encrypted_notify_user_id] = current_user.encrypted_id

    parameters
  end

  def authorize_collection(name, collection)
    collection.each { |element| authorize! name, element }
  end
end
