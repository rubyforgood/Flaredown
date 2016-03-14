class Api::V1::CheckinsController < Api::BaseController
  def index
    date = Date.parse(params.require(:date))
    render json: current_user.checkins.where(date: date)
  end

  def show
    render json: Checkin.find(id)
  end

  def create
    date = params.require(:checkin).require(:date)
    checkin = CheckinCreator.new(current_user.id, Date.parse(date)).create!
    render json: checkin
  end

  def update
    @checkin = Checkin.find(id)
    @checkin.update_attributes!(update_params)
    render json: @checkin
  end

  private

  def update_params
    params.require(:checkin).permit(:note, tag_ids: [],
        conditions_attributes: [:id, :value, :condition_id, :color_id, :_destroy],
        symptoms_attributes: [:id, :value, :symptom_id, :color_id, :_destroy],
        treatments_attributes: [:id, :value, :treatment_id, :is_taken, :color_id, :_destroy]
    ).tap do |p|
      p[:treatments_attributes].select { |t| t[:id].blank? }.each do |t|
        t[:value] = @checkin.most_recent_dose_for(t[:treatment_id])
      end if p[:treatments_attributes].present?
    end
  end

  def id
    params.require(:id)
  end
end
