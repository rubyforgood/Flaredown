class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include ActionController::Serialization
  include ExceptionLogger

  before_action :authenticate_user_from_token!, if: :presence_of_authentication_token?
  before_action :authenticate_user!, except: [:root]
  before_action :set_locale

  def root
    render json: {
      ios: {
        major: 0,
        minor: 0
      },
      android: {
        major: 0,
        minor: 0
      }
    }
  end

  protected

  def set_locale
    I18n.locale = user_signed_in? ? current_user.locale : I18n.default_locale
  rescue I18n::InvalidLocale
    # FIXME
    Rails.logger.warn("'#{current_user.profile.locale}' locale for user '#{current_user.email}' not available or invalid, using default")
    I18n.locale = I18n.default_locale
  end

  private

  def authenticate_user_from_token!
    user = User.find_by(authorization)
    sign_in user, store: false if user
  end

  def authorization
    @authorization ||=
      /^Token token="(?<token>.*)", email="(?<email>.*)"$/.match(request.headers["Authorization"]) || {}

    {authentication_token: @authorization[:token], email: @authorization[:email]}
  end

  def presence_of_authentication_token?
    authorization[:authentication_token].present?
  end
end
