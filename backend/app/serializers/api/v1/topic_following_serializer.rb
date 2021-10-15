module Api
  module V1
    class TopicFollowingSerializer < ApplicationSerializer
      include Concerns::TopicSerializable
    end
  end
end
