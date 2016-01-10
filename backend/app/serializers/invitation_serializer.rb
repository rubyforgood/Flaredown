class InvitationSerializer < ApplicationSerializer
  attributes :id

  has_one :user, include: true
end
