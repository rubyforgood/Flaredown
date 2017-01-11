class Api::V1::StepsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    steps = group.present? ? Step.by_group(group) : Step.all
    render json: steps
  end

  def show
    step = Step.find(step_id)
    # FIXME
    # rubocop:disable Style/SignalException
    fail ActiveRecord::RecordNotFound if step.nil?
    # rubocop:enable Style/SignalException
    render json: step
  end

  private

  def step_id
    params.require(:id)
  end

  def group
    @group ||= params[:group]&.to_sym
  end
end
