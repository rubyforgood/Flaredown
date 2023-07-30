module Api
  module V1
    class CommentSerializer < ApplicationSerializer
      require_dependency 'api/v1/concerns/notificatable'
      require_dependency 'api/v1/concerns/reaction_relatable'
      # before rails 7, these didn't need require_dependency,
      # and were included without explicit scoping
      # in PostsSerializer ReactionRelatable isn't working but it seems to be working here
      # or else is totally untested?  TBD
      include Api::V1::Concerns::Notificatable
      include Api::V1::Concerns::ReactionRelatable

      attributes :post_id, :body, :user_name, :postable_id, :type

      def type
        "comment"
      end

      def postable_id
        :fake
      end
    end
  end
end
