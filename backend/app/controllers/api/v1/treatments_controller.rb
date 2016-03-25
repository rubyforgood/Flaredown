class Api::V1::TreatmentsController < ApplicationController
  load_and_authorize_resource

  def index
    @treatments = @treatments.where(id: ids) if ids.present?
    render json: @treatments
  end

  def show
    render json: @treatment
  end

  def create
    render json: TrackableCreator.new(@treatment, current_user).create!
  end

  private

  def create_params
    params.require(:treatment).permit(:name)
  end

  def ids
    @ids ||= params[:ids]
  end
end
