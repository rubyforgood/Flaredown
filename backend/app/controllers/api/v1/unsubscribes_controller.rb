class Api::V1::UnsubscribesController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    profile = Profile.find_by(notify_token: activation_params[:notify_token])
    profile&.update_attributes(notify: false)

    head :ok
  end

  private

  def activation_params
    params.permit(:notify_token)
  end
end
