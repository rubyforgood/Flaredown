class ApplicationController < ActionController::API
  include ActionController::Serialization

  before_filter :authenticate_user_from_token!, if: :presence_of_authentication_token?

  def root
    render text: 'flaredown'
  end

  private

  def authenticate_user_from_token!
    user = User.find_by(authorization)
    if user
      sign_in user, store: false
    end
  end

  def authorization
    @authorization ||= begin
      /^Token token="(?<token>.*)", email="(?<email>.*)"$/.match(request.headers['Authorization']) || {}
    end
    { authentication_token: @authorization[:token], email: @authorization[:email] }
  end

  def presence_of_authentication_token?
    authorization[:authentication_token].present?
  end

end
