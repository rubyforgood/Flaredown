class Api::V1::PostsController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @posts = @posts.where(_type: 'Post')
    @posts = @posts.fts(params[:query]) if params[:query].present?
    @posts = if params[:id].present? && Post::TOPIC_TYPES.include?(params[:type])
               @posts.where("#{params[:type]}_ids": params[:id].to_i)
             elsif params[:following].present?
               @posts.by_followings(current_user.topic_following)
             else
               @posts
             end

    render json: @posts.order_by(created_at: :desc).page(params[:page]).per(10)
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
      tag_ids: [], symptom_ids: [], condition_ids: [], treatment_ids: []
    )
  end
end
