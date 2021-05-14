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
    includes_params = {
      tags: [],
      foods: [],
      symptoms: [],
      conditions: [],
      treatments: [],
      weathersMeasures: [],
      harveyBradshawIndices: []
    }

    params.permit(:id, :start_at, :end_at, includes: includes_params).tap do |whitelist|
      whitelist[:user] = current_user
    end
  end
end
