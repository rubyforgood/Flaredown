class Invitation
  include ActiveModel::Serialization

  attr_reader :id, :email, :user

  def initialize(id, user)
    @id = id
    @user = user
    @email = user.email
  end

  def accept!(params={})
    User.accept_invitation!( { invitation_token: id }.merge(params) )
  end

  def self.find(id)
    new(id, User.find_by_invitation_token(id, true))
  end

end
