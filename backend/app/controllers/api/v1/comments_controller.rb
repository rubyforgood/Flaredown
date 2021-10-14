module Api
  module V1
    class CommentsController < ApplicationController
      load_and_authorize_resource
      skip_before_action :authenticate_user!, only: [:index]

      def index
        render json: @comments.where(:id.in => params[:ids]).order_by(created_at: :asc)
      end

      def show
        render json: @comment
      end

      def create
        @comment.encrypted_user_id = current_user.encrypted_id

        if @comment.save
          UpdatePostCountersJob.perform_async(parent_id: create_params[:post_id], parent_type: "Post")

          unless @comment.encrypted_user_id == @comment.post.encrypted_user_id
            Notification.create(
              kind: :comment,
              notificateable: @comment,
              encrypted_user_id: @comment.encrypted_user_id,
              encrypted_notify_user_id: @comment.post.encrypted_user_id
            )
          end

          DiscussionMention.perform_async(current_user.encrypted_id, @comment.id.to_s)

          render json: @comment, status: :created
        else
          render json: {errors: @comment.errors}, status: :unprocessable_entity
        end
      end

      private

      def create_params
        params.require(:comment).permit(:body, :post_id)
      end
    end
  end
end
