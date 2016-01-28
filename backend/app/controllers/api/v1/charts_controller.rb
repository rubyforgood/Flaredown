class Api::V1::ChartsController < Api::BaseController

  def show
    chart = Chart.new(chart_params)

    if chart.invalid?
      raise ActiveRecord::RecordInvalid.new(chart)
    end

    render json: chart
  end

  def chart_params
    params.permit(:id, :start_at, :end_at, :filters).tap do |params|
      params[:user] = current_user
    end
  end
end
