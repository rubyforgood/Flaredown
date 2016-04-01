class Api::V1::ChartsController < ApplicationController

  def show
    chart = Chart.new(chart_params)
    if chart.invalid?
      fail ActiveRecord::RecordInvalid.new(chart)
    else
      render json: chart
    end
  end

  def chart_params
    params.permit(:id, :start_at, :end_at, :filters).tap do |whitelist|
      whitelist[:user] = current_user
    end
  end
end
