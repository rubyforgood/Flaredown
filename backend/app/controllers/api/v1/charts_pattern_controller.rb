class Api::V1::ChartsPatternController < ApplicationController
  skip_authorization_check only: :index

  def index
    start_at = charts_pattern_params[:start_at]
    end_at = charts_pattern_params[:end_at]

    patterns = Pattern.where(id: { '$in': charts_pattern_params[:pattern_ids] })

    @charts_patterns = patterns.map do |pattern|
      c = ChartsPattern.new(start_at: start_at, end_at: end_at, pattern_id: pattern.id, user: User.first)
      c.chart_data
    end

    render json: @charts_patterns
  end

  private

  def charts_pattern_params
    params.permit(:start_at, :end_at, pattern_ids: [])
  end
end
