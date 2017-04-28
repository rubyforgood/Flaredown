class Api::V1::NotificationsController < ApplicationController
  def destroy
    notifications = Notification.where(notification_params)

    notifications.each { |notification| authorize! :destroy, notification }

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
end
