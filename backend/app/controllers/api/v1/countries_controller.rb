class Api::V1::CountriesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: Country.all
  end

  def show
    country = Country.find_country_by_alpha2(alpha2)
    # FIXME
    # rubocop:disable Style/SignalException
    fail ActiveRecord::RecordNotFound if country.nil?
    # rubocop:enable Style/SignalException
    render json: country
  end

  private

  def alpha2
    id = params.require(:id)
    match_data = /^[[:alpha:]]{2}$/.match(id)
    # FIXME
    # rubocop:disable Style/SignalException
    fail(ActionController::BadRequest, "id param must be a 2 alphabetic characters string") if match_data.nil?
    # rubocop:enable Style/SignalException
    match_data[0]
  end
end
