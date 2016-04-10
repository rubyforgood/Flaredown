class Api::V1::CheckinsController < ApplicationController
  def index
    date = Date.parse(params.require(:date))
    render json: current_user.checkins.where(date: date)
  end

  def show
    render json: Checkin.find(id)
  end

  def create
    date = params.require(:checkin).require(:date)
    checkin = CheckinCreator.new(current_user.id, Date.parse(date)).create!
    render json: checkin
  end

  def update
    render json: Checkin::Updater.new(current_user, params).update!
  end

  private

  def id
    params.require(:id)
  end
end
