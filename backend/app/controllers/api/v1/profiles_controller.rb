class Api::V1::ProfilesController < Api::BaseController
  before_action :check_authorization

  def show
    render json: current_user.profile
  end

  def update
    current_user.profile.update_attributes!(update_params)
    render json: current_user.profile
  end

  private

  def check_authorization
    fail UnauthorizedException unless current_user && profile_id.eql?(current_user.profile.id)
  end

  def profile_id
    id = params.require(:id)
    match_data = /^[[:digit:]]*$/.match(id)
    fail ActionController::BadRequest.new("id param must be a number") if match_data.nil?
    match_data[0].to_i
  end

  def update_params
    params.require(:profile).permit(:country_id, :birth_date, :sex_id)
  end

end
