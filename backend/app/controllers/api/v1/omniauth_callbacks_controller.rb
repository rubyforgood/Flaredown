class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  Devise.omniauth_providers.each do |provider|
    define_method provider do
      handle_omniauth
    end
  end

  def failure
    Rails.logger.warn("Api::V1::OmniauthCallbacksController#failure: #{failure_message}".yellow)
    render json: {errors: failure_message}, status: 401
  end

  private

  def handle_omniauth
    user = User.find_for_database_authentication(email: email_param)
    if user && user.invitation_token.nil?
      render json: user, root: false, serializer: SessionSerializer
    else
      render json: {errors: "User not found"}, status: 401
    end
  end

  def oauth_params
    @oauth_params ||= ActionController::Parameters.new(request.env["omniauth.auth"])
  end

  def email_param
    oauth_params.fetch(:info).fetch(:email)
  end
end
