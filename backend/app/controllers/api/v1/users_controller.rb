class Api::V1::UsersController < Api::BaseController
  load_and_authorize_resource

  def show
    render json: @user
  end
end
