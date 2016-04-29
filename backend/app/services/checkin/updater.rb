class Checkin::Updater
  attr_reader :current_user, :permitted_params, :id

  def initialize(current_user, params)
    @current_user = current_user
    @permitted_params = params.require(:checkin).permit(
      :note, tag_ids: [],
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
    update_trackable_usages
    checkin
  end

  private

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

  def update_trackable_usages
    %w(Condition Symptom Treatment).each do |trackable_class_name|
      update_removed_trackables_usages(trackable_class_name)
      update_added_trackables_usages(trackable_class_name)
    end
  end

  # For trackables that have been removed from checkin, look for TrackbleUsage records
  # for the current user. When a record exists with count 1 it's destroyed,
  # else count is decremented
  def update_removed_trackables_usages(trackable_class_name)
    attrs_key = "#{trackable_class_name.downcase.pluralize}_attributes".to_sym
    trackables_attrs = permitted_params[attrs_key]
    return unless trackables_attrs.present?
    removed_trackables = trackables_attrs.select { |attrs| attrs[:_destroy].eql?('1') }
    trackable_class = trackable_class_name.constantize
    trackable_id_key = "#{trackable_class_name.downcase}_id".to_sym
    removed_trackables.each do |t|
      trackable_usage = TrackableUsage.find_by(
        user: current_user,
        trackable: trackable_class.find(t[trackable_id_key])
      )
      if trackable_usage.present?
        if trackable_usage.count.eql?(1)
          trackable_usage.destroy
        else
          trackable_usage.decrement! :count
        end
      end
    end
  end

  # For trackables that have been added to checkin, look for TrackbleUsage records
  # for the current user. When a record exists its count is incremented,
  # else a new record is created
  def update_added_trackables_usages(trackable_class_name)
    attrs_key = "#{trackable_class_name.downcase.pluralize}_attributes".to_sym
    trackables_attrs = permitted_params[attrs_key]
    return unless trackables_attrs.present?
    added_trackables = trackables_attrs.select { |attrs| attrs[:id].blank? }
    trackable_class = trackable_class_name.constantize
    trackable_id_key = "#{trackable_class_name.downcase}_id".to_sym
    added_trackables.each do |t|
      trackable = trackable_class.find(t[trackable_id_key])
      TrackableUsage.create_or_update_by(user: current_user, trackable: trackable)
    end
  end

end
