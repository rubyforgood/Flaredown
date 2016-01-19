module Authenticatable
  extend ActiveSupport::Concern

  included do
    #
    # Devise
    #
    devise  :database_authenticatable,
            :rememberable,
            :trackable,
            :validatable,
            :invitable,
            :omniauthable
  end
end
