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
    # FIXME
    # rubocop:disable Rails/DynamicFindBy
    user = User.find_by_invitation_token(id, true)
    # rubocop:enable Rails/DynamicFindBy
    # FIXME
    # rubocop:disable Style/SignalException
    fail ActiveRecord::RecordNotFound if user.nil?
    # rubocop:enable Style/SignalException
    new(id, user)
  end
end
