class Api::V1::PostsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:id].present? && Post::TOPIC_TYPES.include?(params[:type])
      @posts = @posts.where("#{params[:type]}_ids": params[:id].to_i)

      if params[:query].present?
        @posts = @posts.fts(params[:query])
      end
    end

    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    @post.encrypted_user_id = current_user.encrypted_id

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:post).permit(
      :title, :body,
      tag_ids: [], food_ids: [], symptom_ids: [], condition_ids: [], treatment_ids: []
    )
  end
end
