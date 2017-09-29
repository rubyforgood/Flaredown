class Api::V1::PatternsController < ApplicationController
  # load_and_authorize_resource

  def show
    pattern = Pattern.new(pattern_params)

    # rubocop:disable Style/SignalException
    fail(ActiveRecord::RecordInvalid, pattern) if pattern.invalid?
    # rubocop:enable Style/SignalException

    render json: pattern
  end

  def create
    binding.pry

  end

  def pattern_params
    params.require(:pattern)
  end
end
