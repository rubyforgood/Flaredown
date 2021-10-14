class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource

  def show
    render json: @user
  end

  def update
    @user.update!(user_params)

    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
