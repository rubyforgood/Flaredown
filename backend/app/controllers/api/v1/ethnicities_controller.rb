class Api::V1::EthnicitiesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: Ethnicity.all
  end

  def show
    ethnicity = Ethnicity.find(ethnicity_id)
    render json: ethnicity
  end

  private

  def ethnicity_id
    id = params.require(:id)
    fail ActionController::BadRequest.new('id param is not a valid ethnicity id') unless Ethnicity.all_ids.include?(id)
    id
  end
end
