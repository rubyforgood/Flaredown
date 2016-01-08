class Invitation
  include ActiveModel::Serialization

  attr_accessor :id, :user

  def initialize(user)
    @user = user
  end

end
