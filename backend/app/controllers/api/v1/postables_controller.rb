class Api::V1::PostablesController < ApplicationController
  load_and_authorize_resource

  def index
    data = @postables
      .where(encrypted_user_id: current_user.encrypted_id)
      .order_by(created_at: :desc)
      .page(params[:page])
      .per(20)

    render json: data
  end
end
