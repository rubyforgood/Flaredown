class Api::V1::WeathersController < ApplicationController
  def index
    weather = WeatherRetriver.get(Date.parse(params.require(:date)), params.require(:postal_code))

    authorize! :read, weather

    render json: weather
  end
end
