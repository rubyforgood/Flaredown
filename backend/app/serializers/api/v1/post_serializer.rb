module Api
  module V1
    class PostSerializer < ApplicationSerializer
      require_dependency 'api/v1/concerns/notificatable'
      include Api::V1::Concerns::Notificatable
      # before rails 7, these additional concerns were included,
      # but they don't seem to work anymore?  TBD

      # require_dependency 'api/v1/concerns/topic_serializable'
      # require_dependency 'api/v1/concerns/reaction_relatable'
      # include Api::V1::Concerns::TopicSerializable
      # include Api::V1::Concerns::ReactionRelatable

      attributes :id, :body, :title, :type, :user_name, :comments_count, :postable_id, :priority

      has_many :comments, embed: :ids

      def type
        "post"
      end

      def priority
        object.try(:priority)
      end
    end
  end
end
