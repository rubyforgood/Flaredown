class Api::V1::CountriesController < Api::BaseController

  def index
    render json: Country.all, each_serializer: CountrySerializer
  end

  def show
    country = Country.find_country_by_alpha2(alpha2)
    raise ActiveRecord::RecordNotFound if country.nil?
    render json: country, each_serializer: CountrySerializer
  end

  private

  def alpha2
    id = params.require(:id)
    match_data = /^[[:alpha:]]{2}$/.match(id)
    raise ActionController::BadRequest.new("id param must be a 2 alphabetic characters string") if match_data.nil?
    match_data[0]
  end

end
