class CommentSerializer < ApplicationSerializer
  attributes :post_id, :body, :user_name, :type

  def type
    'comment'
  end
end
