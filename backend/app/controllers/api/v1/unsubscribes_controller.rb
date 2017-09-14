class Api::V1::UnsubscribesController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    @profile = Profile.find_by(notify_token: activation_params[:notify_token])
    attribute_key = activation_params[:notify_top_posts].present? ? :notify_top_posts : :notify

    @profile&.update_column(attribute_key, false)

    render json: @profile
  end

  private

  def activation_params
    params.permit(:notify_token, :notify_top_posts, :stop_remind)
  end
end
