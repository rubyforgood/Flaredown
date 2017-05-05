class Api::V1::CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    render json: @comments.where(:id.in => params[:ids]).order_by(created_at: :asc)
  end

  def show
    render json: @comment
  end

  def create
    @comment.encrypted_user_id = current_user.encrypted_id

    if @comment.save
      unless @comment.encrypted_user_id == @comment.post.encrypted_user_id
        Notification.create(
          kind: :comment,
          notificateable: @comment,
          encrypted_user_id: @comment.encrypted_user_id,
          encrypted_notify_user_id: @comment.post.encrypted_user_id
        )
      end

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
