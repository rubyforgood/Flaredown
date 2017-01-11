class Api::V1::ChartsController < ApplicationController

  def show
    chart = Chart.new(chart_params)

    # FIXME
    # rubocop:disable Style/SignalException
    fail(ActiveRecord::RecordInvalid, chart) if chart.invalid?
    # rubocop:enable Style/SignalException

    render json: chart
  end

  def chart_params
    params.permit(:id, :start_at, :end_at, :filters).tap do |whitelist|
      whitelist[:user] = current_user
    end
  end
end
