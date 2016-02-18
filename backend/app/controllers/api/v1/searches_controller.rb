class Api::V1::SearchesController < Api::BaseController
  def show
    search =
      if resource_param.eql? 'dose'
        Search::Dose.new(search_params)
      else
        Search.new(search_params)
      end

    fail ActiveRecord::RecordInvalid.new(search) if search.invalid?

    render json: search, serializer: SearchSerializer
  end

  def search_params
    params.permit(:resource, query: [:name, :treatment_id]).tap do |params|
      params[:user] = current_user
    end
  end

  def resource_param
    params[:resource]
  end
end
