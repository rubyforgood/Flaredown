class Api::V1::SexesController < Api::BaseController

  def index
    render json: Sex.all
  end

  def show
    sex = Sex.new(sex_id)
    render json: sex
  end

  private

  def sex_id
    id = params.require(:id)
    raise ActionController::BadRequest.new("id param is not a valid sex id") unless Sex.all_ids.include?(id)
    id
  end

end
