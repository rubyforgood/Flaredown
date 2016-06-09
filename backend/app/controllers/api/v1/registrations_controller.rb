class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    render json: Registration.create!(params)
  end

end
