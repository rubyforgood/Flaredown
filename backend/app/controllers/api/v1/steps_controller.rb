class Api::V1::StepsController < Api::BaseController

  def index
    steps = group.present? ? Step.by_group(group) : Step.all
    render json: steps
  end

  def show
    step = Step.find(step_id)
    fail ActiveRecord::RecordNotFound if step.nil?
    render json: step
  end

  private

  def step_id
    params.require(:id)
  end

  def group
    @group ||= params[:group].to_sym rescue nil
  end

end
