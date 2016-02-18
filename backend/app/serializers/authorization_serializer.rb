class AuthorizationSerializer < ApplicationSerializer
  attributes :id, :user_id, :email, :token

  def id
    1
  end

  def user_id
    object.try :id
  end

  def email
    object.try :email
  end

  def token
    object.try :authentication_token
  end
end
