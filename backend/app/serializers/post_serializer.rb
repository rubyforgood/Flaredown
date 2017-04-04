class PostSerializer < ApplicationSerializer
  include TopicSerializable

  attributes :id, :body, :title, :type, :user_name, :comments_count, :postable_id

  has_many :comments, embed: :ids

  def type
    'post'
  end
end
