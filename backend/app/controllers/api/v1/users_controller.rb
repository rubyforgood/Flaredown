class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource

  def show
    render json: @user
  end
end
