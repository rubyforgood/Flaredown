module Api
  module V1
    class CommentSerializer < ApplicationSerializer
      include Concerns::Notificatable
      include Concerns::ReactionRelatable

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
