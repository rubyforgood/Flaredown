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
    fail ActionController::BadRequest.new('id param is not a valid education_level id') unless EducationLevel.all_ids.include?(id)
    id
  end
end
