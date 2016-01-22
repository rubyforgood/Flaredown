class Api::V1::StepsController < Api::BaseController

  def index
    render json: Step.all
  end

  def show
    step = Step.find(step_id)
    fail ActiveRecord::RecordNotFound if step.nil?
    render json: step
  end

  private

  def step_id
    params.require(:id).to_i
  end

end
