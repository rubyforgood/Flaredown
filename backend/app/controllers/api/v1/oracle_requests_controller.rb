class Api::V1::OracleRequestsController < ApplicationController
  skip_before_action :authenticate_user!

  load_resource

  def show
    render json: @oracle_request
  end

  def create
    @oracle_request.save

    render json: @oracle_request
  end

  private

  def create_params
    params.require(:oracle_request).permit(
      :age,
      :sex_id,
      responce: [
        :name,
        :confidence,
        :correction
      ],
      symptom_ids: []
    )
  end
end
