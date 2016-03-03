module Authenticatable
  extend ActiveSupport::Concern

  included do
    #
    # Devise
    #
    devise :database_authenticatable,
           :rememberable,
           :recoverable,
           :trackable,
           :validatable,
           :invitable,
           :omniauthable
  end
end
