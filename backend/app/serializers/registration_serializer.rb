class RegistrationSerializer < ApplicationSerializer
  has_one :user, embed_in_root: true

  private

  def id
    object.user.id
  end

end
