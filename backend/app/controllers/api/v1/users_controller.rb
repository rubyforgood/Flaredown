class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show
    render json: @user
  end
end
