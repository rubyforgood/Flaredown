class Api::V1::CheckinsController < Api::BaseController

  def index
    date = Date.parse(params.require(:date))
    render json: current_user.checkins.where(date: date)
  end

  def show
    render json: Checkin.find(params[:id])
  end

  def create
    date = params.require(:checkin).require(:date)
    checkin = CheckinCreator.new(current_user.id, Date.parse(date)).create!
    render json: checkin
  end

end
