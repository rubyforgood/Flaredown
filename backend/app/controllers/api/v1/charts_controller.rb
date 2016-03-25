class Api::V1::ChartsController < ApplicationController

  def show
    chart = Chart.new(chart_params)

    fail ActiveRecord::RecordInvalid.new(chart) if chart.invalid?

    render json: chart
  end

  def chart_params
    params.permit(:id, :start_at, :end_at, :filters).tap do |params|
      params[:user] = current_user
    end
  end
end
