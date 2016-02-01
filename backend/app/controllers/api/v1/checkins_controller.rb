class Api::V1::CheckinsController < Api::BaseController

  def show
    render json: Checkin.find(params[:id])
  end

end
