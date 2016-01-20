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
    fail UnauthorizedException unless current_user && fetch_numeric_id_param.eql?(current_user.profile.id)
  end

  def update_params
    params.require(:profile).permit(:country_id, :birth_date, :sex_id)
  end

end
