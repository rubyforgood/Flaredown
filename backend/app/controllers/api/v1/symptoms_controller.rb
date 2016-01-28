class Api::V1::SymptomsController < Api::BaseController
  load_and_authorize_resource

  def index
    render json: @symptoms
  end

  def show
    render json: @symptom
  end

  def create
    UserSymptom.create!(user: current_user, symptom: @symptom)
    render json: @symptom.reload
  end

  private

  def create_params
    params.require(:symptom).permit(:name)
  end

end
