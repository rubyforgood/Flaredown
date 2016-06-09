class Api::V1::TreatmentsController < ApplicationController
  load_and_authorize_resource

  def index
    @treatments = @treatments.includes(:translations)
    if ids.present?
      @treatments = @treatments.where(id: ids)
    else
      @treatments = @treatments.order(:name).limit(50)
    end
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
    @ids ||=
      if params[:ids].is_a?(Array)
        params[:ids]
      end
  end
end
