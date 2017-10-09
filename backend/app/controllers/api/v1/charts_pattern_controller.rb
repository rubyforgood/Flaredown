class Api::V1::ChartsPatternController < ApplicationController
  skip_authorization_check only: :index

  def index
    start_at = charts_pattern_params[:start_at]
    end_at = charts_pattern_params[:end_at]

    @patterns = Pattern.where(id: { '$in': charts_pattern_params[:pattern_ids] })

    @extended_patterns = @patterns.map do |pattern|
        pattern.extend(PatternExtender).form_chart_data(start_at: start_at, end_at: end_at, pattern: pattern, user: User.first)
      end

    render json: @extended_patterns
  end

  private

  def charts_pattern_params
    params.permit(:start_at, :end_at, pattern_ids: [])
  end
end
