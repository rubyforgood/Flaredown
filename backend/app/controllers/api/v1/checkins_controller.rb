class Api::V1::CheckinsController < ApplicationController

  def index
    date = params[:date]

    if date.blank? && params.require(:page)
      render json: current_user.checkins.where(:note.nin => [nil, '']).order_by(date: :desc).page(params[:page]).per(10)
    else
      render json: current_user.checkins.where(date: Date.parse(date))
    end
  end

  def show
    render json: Checkin.find(id)
  end

  def create
    date = params.require(:checkin).require(:date)
    checkin = Checkin::Creator.new(current_user.id, Date.parse(date)).create!
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
