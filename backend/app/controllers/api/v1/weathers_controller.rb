class Api::V1::WeathersController < ApplicationController
  def index
    unless params[:postal_code].blank?
      weather = WeatherRetriever.get(Date.parse(params.require(:date)), params.require(:postal_code))
    end

    authorize! :read, weather

    if weather.present?
      render json: weather
    else
      render json: { weathers: [] }
    end
  end
end
