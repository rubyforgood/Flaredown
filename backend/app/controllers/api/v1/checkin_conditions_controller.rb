class Api::V1::CheckinConditionsController < Api::BaseController

  def destroy
    Checkin::Condition.find(id).destroy
    head :no_content
  end

  private

  def id
    params.require(:id)
  end

end
