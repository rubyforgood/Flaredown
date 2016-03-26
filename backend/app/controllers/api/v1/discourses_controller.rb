class Api::V1::DiscoursesController < ApplicationController

  def create
    client = DiscourseClient.new(current_user, params)
    Rails.logger.debug("discourse: #{current_user}".red)
    render json: { sso_url: client.to_url }
  end

end
