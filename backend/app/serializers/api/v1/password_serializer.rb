module Api
  module V1
    class PasswordSerializer < ApplicationSerializer
      attributes :id, :email, :reset_password_token, :current_password, :password, :password_confirmation

      def id
        if reset_password_token.present?
          reset_password_token
        else
          Digest::SHA256.base64digest(DateTime.current.to_s)
        end
      end

      def email
        object.try :email
      end

      def reset_password_token
        serialization_options[:token]
      end

      def password
      end

      def password_confirmation
      end

      def current_password
      end
    end
  end
end
