class Api::V1::SummaryPostsController < ApplicationController
  authorize_resource
  skip_before_action :authenticate_user!, only: :index

  def index
    render json: SummaryPosts.new(current_user).show_list
  end
end
