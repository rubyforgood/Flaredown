class Api::V1::ChartsPatternController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    offset = charts_pattern_params[:offset].to_i
    start_at = (charts_pattern_params[:start_at].to_date - offset.days).to_s

    end_date = charts_pattern_params[:end_at].to_date
    end_at = (Time.current.to_date == end_date ? end_date : (end_date + offset.days)).to_s

    @patterns = Pattern.where(id: { '$in': charts_pattern_params[:pattern_ids] || [] })

    @extended_patterns = @patterns.map do |pattern|
      pattern.extend(PatternExtender).form_chart_data(start_at: start_at,
                                                      end_at: end_at,
                                                      pattern: pattern)
    end

    render json: @extended_patterns, meta: { color_ids: Flaredown::Colorable::IDS }
  end

  private

  def charts_pattern_params
    params.permit(:start_at, :end_at, :offset, pattern_ids: [])
  end
end
