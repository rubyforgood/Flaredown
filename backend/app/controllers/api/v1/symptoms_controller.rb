class Api::V1::SymptomsController < ApplicationController
  load_and_authorize_resource

  def index
    @symptoms = @symptoms.includes(:translations)
    if ids.present?
      @symptoms = @symptoms.where(id: ids)
    else
      @symptoms = @symptoms.order(:name).limit(50)
    end
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
    @ids ||=
      if params[:ids].is_a?(Array)
        params[:ids]
      end
  end
end
