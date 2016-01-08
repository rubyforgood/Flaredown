class InvitationSerializer < ApplicationSerializer
  attributes :id

  has_one :user
end
