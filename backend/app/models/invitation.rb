class Invitation
  include ActiveModel::Serialization

  attr_reader :id, :email, :user

  def initialize(id, user)
    @id = id
    @user = user
    @email = user.email
  end

  def accept!(params = {})
    User.accept_invitation!({ invitation_token: id }.merge(params))
  end

  def self.find(id)
    user = User.find_by_invitation_token(id, true)
    fail ActiveRecord::RecordNotFound if user.nil?
    new(id, user)
  end
end
