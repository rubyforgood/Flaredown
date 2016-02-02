class Api::V1::CheckinsController < Api::BaseController

  def index
    render json: Checkin.where(date: date)
  end

  def show
    render json: Checkin.find(params[:id])
  end

  private

  def date
    Date.parse(params.require(:date))
  end

end
