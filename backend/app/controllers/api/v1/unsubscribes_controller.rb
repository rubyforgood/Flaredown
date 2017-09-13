class Api::V1::UnsubscribesController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    profile = Profile.find_by(notify_token: activation_params[:notify_token])
    updated_data = activation_params[:stop_remind].present? ? { checkin_reminder: false } : { notify: false }

    profile&.update_attributes(updated_data)

    head :ok
  end

  private

  def activation_params
    params.permit(:notify_token, :stop_remind)
  end
end
