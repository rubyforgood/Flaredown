class Api::V1::PromotionRatesController < ApplicationController
  load_and_authorize_resource

  def show
    render json: @promotion_rate
  end

  def create
    @promotion_rate.save

    render json: @promotion_rate
  end

  private

  def resource_params
    params.require(:promotion_rate).permit(:checkin_id, :score)
  end
end
