class Api::V1::PasswordsController < Api::BaseController

  def show
    user = User.with_reset_password_token(params[:id])
    render json: user, token: params[:id], serializer: PasswordSerializer
  end

  def create
    user = User.find_by!(email: params.require(:password).fetch(:email))

    if user && user.send_reset_password_instructions
      render json: user, serializer: PasswordSerializer
    end
  end

  def update
    if user_signed_in?
      user = current_user
    else
      user = User.reset_password_by_token(
        params.require(:password).permit(:reset_password_token, :password, :password_confirmation)
      )
    end

    render json: user, token: params[:id], serializer: PasswordSerializer
  end

end
