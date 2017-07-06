class Api::V1::PostsController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:summary]
      render json: SummaryPosts.new(current_user).show_list
    else
      @posts = DiscussionPosts.new(params, current_user).show_list

      render json: @posts.order(last_commented: :desc, created_at: :desc).page(params[:page]).per(10)
    end
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
