class Api::V1::SessionsController < ApplicationController
  def show
    render json: session
  end

  private

  def session
    @session ||= Session.new
  end

end
