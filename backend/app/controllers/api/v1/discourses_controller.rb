class Api::V1::DiscoursesController < ApplicationController
  def create
    render json: {url: DiscourseClient.new(current_user, params).generate_url}
  end
end
