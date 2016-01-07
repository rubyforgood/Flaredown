class Api::V1::SessionsController < ApplicationController

  def show
    render json: Flaredown.session
  end

  def create
    fail 'missing params' if params[:user].nil?
    fail 'invalid email or password' if user.nil?

    render json: user, root: false, serializer: AuthorizationSerializer
  rescue => e
    Rails.logger.debug(e.inspect.red)
    render json: { errors: Array(e.message) }, status: 401
  end

  private

  def user
    @user ||= begin
      user = User.find_for_database_authentication(email: params[:user][:email])
      if user && user.valid_password?(params[:user][:password])
        user
      else
        nil
      end
    end
  end
end
