class Api::V1::EducationLevelsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: EducationLevel.all
  end

  def show
    education_level = EducationLevel.find(education_level_id)
    render json: education_level
  end

  private

  def education_level_id
    id = params.require(:id)
    # FIXME
    # rubocop:disable Style/SignalException
    unless EducationLevel.all_ids.include?(id)
      fail(ActionController::BadRequest, "id param is not a valid education_level id")
    end
    # rubocop:enable Style/SignalException
    id
  end
end
