class Api::V1::SymptomsController < ApplicationController
  load_and_authorize_resource

  def index
    @symptoms = @symptoms.includes(:translations)
    @symptoms = @symptoms.where(id: ids) if ids.present?
    render json: @symptoms
  end

  def show
    render json: @symptom
  end

  def create
    render json: TrackableCreator.new(@symptom, current_user).create!
  end

  private

  def create_params
    params.require(:symptom).permit(:name)
  end

  def ids
    @ids ||= params[:ids]
  end
end
