class Api::V1::PatternsController < ApplicationController
  def show
    pattern = Pattern.new(pattern_params)

    # rubocop:disable Style/SignalException
    fail(ActiveRecord::RecordInvalid, pattern) if pattern.invalid?
    # rubocop:enable Style/SignalException

    render json: pattern
  end

  def create

  end

  def pattern_params
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
