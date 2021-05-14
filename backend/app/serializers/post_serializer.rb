class PostSerializer < ApplicationSerializer
  include Notificatable
  include TopicSerializable
  include ReactionRelatable

  attributes :id, :body, :title, :type, :user_name, :comments_count, :postable_id, :priority

  has_many :comments, embed: :ids

  def type
    "post"
  end

  def priority
    object.try(:priority)
  end
end
