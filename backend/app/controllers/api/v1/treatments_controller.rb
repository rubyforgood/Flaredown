class Api::V1::TreatmentsController < Api::BaseController
  load_and_authorize_resource

  def index
    render json: @treatments
  end

  def show
    render json: @treatment
  end

  def create
    UserTreatment.create!(user: current_user, treatment: @treatment)
    render json: @treatment.reload
  end

  private

  def create_params
    params.require(:treatment).permit(:name)
  end

end
