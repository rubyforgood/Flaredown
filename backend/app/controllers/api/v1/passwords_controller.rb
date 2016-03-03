class Api::V1::PasswordsController < Api::BaseController

  def show
    if user_signed_in?
      user = current_user
    else
      user = User.with_reset_password_token(params[:id])
    end
    render json: user, token: params[:id], serializer: PasswordSerializer
  end

  def create
    user = User.find_by!(email: email_params)

    if user && user.send_reset_password_instructions
      render json: user, serializer: PasswordSerializer
    end
  end

  def update
    if user_signed_in?
      user = current_user
      user.update(
        params.require(:password).permit(:password, :password_confirmation)
      )
    else
      user = User.reset_password_by_token(
        params.require(:password).permit(:reset_password_token, :password, :password_confirmation)
      )
    end

    render json: user, token: params[:id], serializer: PasswordSerializer
  end

  private

  def email_params
     params.require(:password).fetch(:email)
  end
end
