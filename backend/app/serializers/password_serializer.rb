class PasswordSerializer < ApplicationSerializer
  attributes :id, :email, :reset_password_token

  def id
    if reset_password_token.present?
      reset_password_token
    else
      Digest::SHA256.base64digest(DateTime.now.to_s)
    end
  end

  def email
    object.try :email
  end

  def reset_password_token
    serialization_options[:token]
  end
end
