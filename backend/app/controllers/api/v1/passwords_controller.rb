class Api::V1::PasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    user = user_signed_in? ? current_user : User.with_reset_password_token(params[:id])

    if user.blank?
      raise ActiveRecord::RecordNotFound, "User not found"
    else
      render json: user, token: params[:id], serializer: PasswordSerializer
    end
  end

  def create
    user = User.find_by!("LOWER(email) = ?", email_param.downcase)

    return unless user.send_reset_password_instructions

    render json: user, serializer: PasswordSerializer
  end

  def update
    if user_signed_in?
      if current_user.update_with_password(update_password_params)
        render json: current_user, token: params[:id], serializer: PasswordSerializer
      else
        render json: {errors: current_user.errors}, status: :unprocessable_entity
      end
    else
      user = User.reset_password_by_token(update_password_by_token_params)
      if user.errors.empty?
        render json: user, token: params[:id], serializer: PasswordSerializer
      else
        render json: {errors: user.errors}, status: :unprocessable_entity
      end
    end
  end

  private

  def email_param
    params.require(:password).fetch(:email)
  end

  def update_password_params
    params.require(:password).permit(:current_password, :password, :password_confirmation)
  end

  def update_password_by_token_params
    params.require(:password).permit(:reset_password_token, :password, :password_confirmation)
  end
end
