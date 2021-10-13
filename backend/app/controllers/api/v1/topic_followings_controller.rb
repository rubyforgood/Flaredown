class Api::V1::TopicFollowingsController < ApplicationController
  load_and_authorize_resource

  def show
    render json: @topic_following
  end

  def update
    if @topic_following.update(update_params)
      render json: @topic_following, status: :ok
    else
      render json: {errors: @topic_following.errors}, status: :unprocessable_entity
    end
  end

  private

  def update_params
    empty_params = {
      "tag_ids" => [],
      "symptom_ids" => [],
      "condition_ids" => [],
      "treatment_ids" => []
    }

    empty_params.merge(params.require(:topic_following).permit(empty_params))
  end
end
