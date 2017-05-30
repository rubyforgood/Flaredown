class Api::V1::OracleRequestsController < ApplicationController
  skip_before_action :authenticate_user!

  serialization_scope :oracle_token

  load_resource

  def show
    render json: @oracle_request
  end

  def create
    if oracle_token.present?
      @oracle_request.token = oracle_token
    else
      loop do
        @oracle_request.token = SecureRandom.uuid

        break unless OracleRequest.where(token: @oracle_request.token).exists?
      end
    end

    @oracle_request.save

    render json: @oracle_request, serializer: OracleRequestWithTokenSerializer
  end

  def update
    if @oracle_request.can_edit?(oracle_token)
      @oracle_request.update_attributes!(create_params)

      render json: @oracle_request
    else
      render json: { errors: 'Unauthorized' }, status: :unauthorised
    end
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

  def oracle_token
    request.headers['X-Oracle-Token']
  end
end
