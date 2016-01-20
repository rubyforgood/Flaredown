class Api::V1::UsersController < Api::BaseController
  before_action :check_authorization

  def show
    render json: current_user
  end

  private

  def check_authorization
    fail UnauthorizedException unless current_user && fetch_numeric_id_param.eql?(current_user.id)
  end

end
