class Api::V1::PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @posts = @posts.where(_type: 'Post')

    @posts = if params[:id].present? && Post::TOPIC_TYPES.include?(params[:type])
      @posts.where("#{params[:type]}_ids": params[:id].to_i)
    else
      followings = current_user.topic_following

      @posts
        .or(:tag_ids.in => followings.tag_ids)
        .or(:food_ids.in => followings.food_ids)
        .or(:symptom_ids.in => followings.symptom_ids)
        .or(:condition_ids.in => followings.condition_ids)
        .or(:treatment_ids.in => followings.treatment_ids)
    end

    @posts = @posts.fts(params[:query]) if params[:query].present?

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
      tag_ids: [], food_ids: [], symptom_ids: [], condition_ids: [], treatment_ids: []
    )
  end
end
