class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    # FIXME
    # rubocop:disable Style/SignalException
    fail "missing information" if params[:user].nil?
    fail "invalid email or password" if user.nil?
    # rubocop:enable Style/SignalException

    render json: user, root: false, serializer: SessionSerializer
  rescue => e
    render json: {errors: Array(e.message)}, status: 401
  end

  private

  def user
    @user ||=
      begin
        user = User.find_for_database_authentication(email: params[:user][:email])
        user if user && user.valid_password?(params[:user][:password])
      end
  end
end
