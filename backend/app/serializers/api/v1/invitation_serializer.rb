module Api
  module V1
    class InvitationSerializer < ApplicationSerializer
      attributes :id, :email

      has_one :user, embed_in_root: true
    end
  end
end
