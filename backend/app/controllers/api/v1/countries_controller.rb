class Api::V1::CountriesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: Country.all
  end

  def show
    country = Country.find_country_by_alpha2(alpha2)
    fail ActiveRecord::RecordNotFound if country.nil?
    render json: country
  end

  private

  def alpha2
    id = params.require(:id)
    match_data = /^[[:alpha:]]{2}$/.match(id)
    fail ActionController::BadRequest.new('id param must be a 2 alphabetic characters string') if match_data.nil?
    match_data[0]
  end
end
