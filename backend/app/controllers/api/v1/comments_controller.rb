class Api::V1::CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @comment.encrypted_user_id = current_user.encrypted_id

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:comment).permit(:body, :post_id)
  end
end
