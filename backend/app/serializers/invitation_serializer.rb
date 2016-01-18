class InvitationSerializer < ApplicationSerializer
  attributes :id, :email

  has_one :user, include: true
end
