class Checkin::Updater
  attr_reader :current_user, :permitted_params, :id

  def initialize(current_user, params)
    @current_user = current_user
    @permitted_params = params.require(:checkin).permit(:note, tag_ids: [],
        conditions_attributes: [:id, :value, :condition_id, :color_id, :_destroy],
        symptoms_attributes: [:id, :value, :symptom_id, :color_id, :_destroy],
        treatments_attributes: [:id, :value, :treatment_id, :is_taken, :color_id, :_destroy]
    ).tap do |p|
      p[:treatments_attributes].select { |t| t[:id].blank? }.each do |t|
        t[:value] = current_user.profile.most_recent_dose_for(t[:treatment_id])
      end if p[:treatments_attributes].present?
      p[:tag_ids] = [] if p[:tag_ids].nil?
    end
    @id = params.require(:id)
  end

  def update!
    checkin = Checkin.find(id)
    checkin.update_attributes!(permitted_params)
    save_most_recent_doses if checkin.date.today?
    checkin
  end

  def save_most_recent_doses
    treatments_attributes = permitted_params[:treatments_attributes]
    return if treatments_attributes.blank?
    treatments_with_doses = treatments_attributes
      .reject { |t| (t[:value].blank? || t[:is_taken].eql?('false')) }
    return if treatments_with_doses.empty?
    treatments_with_doses.each do |t|
      current_user.profile.set_most_recent_dose(
        t[:treatment_id], t[:value]
      )
    end
    current_user.profile.save!
  end

end

