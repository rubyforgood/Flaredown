class Api::V1::PromotionRatesController < ApplicationController
  load_and_authorize_resource

  def show
    render json: @promotion_rate
  end

  def create
    @promotion_rate.save

    render json: @promotion_rate
  end

  def update
    @promotion_rate.update_attributes(resource_params.merge(additional_params))

    render json: @promotion_rate
  end

  private

  def resource_params
    params.require(:promotion_rate).permit(:checkin_id, :score, :feedback)
  end

  def additional_params
    user = @promotion_rate.checkin.user

    {user_created_at: user.created_at}
  end
end
