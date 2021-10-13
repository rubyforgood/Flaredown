class Checkin::Updater
  attr_reader :current_user, :checkin, :permitted_params

  def initialize(current_user, params)
    @current_user = current_user
    id = params.require(:id)
    @checkin = Checkin.find(id)
    @permitted_params =
      params
        .require(:checkin)
        .permit(
          :note, :postal_code, :weather_id, :promotion_skipped_at,
          tag_ids: [],
          food_ids: [],
          conditions_attributes: [:id, :value, :condition_id, :color_id, :position, :_destroy],
          symptoms_attributes: [:id, :value, :symptom_id, :color_id, :position, :_destroy],
          treatments_attributes: [:id, :value, :treatment_id, :is_taken, :color_id, :position, :_destroy]
        )
        .tap do |p|
          set_most_recent_doses(p[:treatments_attributes])
          update_trackables_positions(p)
          p[:tag_ids] = [] if p[:tag_ids].nil?
          p[:food_ids] = [] if p[:food_ids].nil?
        end
  end

  def update!
    checkin.update!(permitted_params.except(:postal_code))

    if checkin.date.today?
      save_most_recent_doses
      save_most_recent_trackables_positions
    end
    update_trackable_usages

    position = Position.find_or_create_by(postal_code: permitted_params[:postal_code])

    if position.persisted?
      checkin.position_id = position.id
      checkin.save!
    end

    checkin
  end

  private

  def update_trackables_positions(params)
    %w[Condition Symptom Treatment].each do |trackable_class_name|
      update_trackables_positions_on_destroy(trackable_class_name, params)
      set_added_trackables_positions(trackable_class_name, params)
    end
  end

  def update_trackables_positions_on_destroy(trackable_class_name, params)
    trackables_attrs = trackables_attrs(trackable_class_name, params)
    removed_trackables = removed_trackables_attrs(trackables_attrs)
    removed_trackables.each do |removed_trackable|
      trackables_attrs.each do |trackable|
        next if trackable[:position].blank? ||
          removed_trackable[:position].blank? ||
          trackable[:position] <= removed_trackable[:position]

        trackable[:position] -= 1
      end
    end
  end

  def set_added_trackables_positions(trackable_class_name, params)
    trackables_attrs = trackables_attrs(trackable_class_name, params)
    trackable_max = trackables_attrs.reject { |t| t[:position].blank? }.max_by { |t| t[:position] }
    max_position = trackable_max.present? ? trackable_max[:position] : 0
    added_trackables = added_trackables_attrs(trackables_attrs)
    added_trackables.each do |added_trackable|
      if added_trackable[:position].blank?
        max_position += 1
        added_trackable[:position] = max_position
      end
    end
  end

  def save_most_recent_trackables_positions
    %w[condition symptom treatment].each do |trackable_type|
      trackable_class = trackable_type.capitalize.constantize
      trackables_attributes = permitted_params["#{trackable_type.pluralize}_attributes".to_sym]
      next if trackables_attributes.blank?
      trackables_attributes.each do |trackable_attrs|
        trackable = trackable_class.find(trackable_attrs["#{trackable_type}_id".to_sym])
        current_user.profile.set_most_recent_trackable_position(
          trackable, trackable_attrs[:position]
        )
      end
    end
  end

  def set_most_recent_doses(treatments_attrs)
    return if treatments_attrs.blank?

    added_trackables_attrs(treatments_attrs).each do |t|
      t[:value] = current_user.profile.most_recent_dose_for(t[:treatment_id])
    end
  end

  def save_most_recent_doses
    treatments_attributes = permitted_params[:treatments_attributes]
    return if treatments_attributes.blank?
    treatments_with_doses = treatments_attributes.reject { |t| (t[:value].blank? || t[:is_taken].eql?("false")) }
    return if treatments_with_doses.empty?
    treatments_with_doses.each do |t|
      current_user.profile.set_most_recent_dose(
        t[:treatment_id], t[:value]
      )
    end
    current_user.profile.save!
  end

  def update_trackable_usages
    %w[Condition Symptom Treatment].each do |trackable_class_name|
      update_removed_trackables_usages(trackable_class_name)
      update_added_trackables_usages(trackable_class_name)
    end

    %w[Tag Food].each do |health_class_name|
      update_health_factors_trackable_usages(health_class_name)
    end
  end

  # For trackables that have been removed from checkin, look for TrackableUsage records
  # for the current user. When a record exists with count 1 it's destroyed,
  # else count is decremented
  def update_removed_trackables_usages(trackable_class_name)
    removed_trackables = removed_trackables_attrs(
      trackables_attrs(trackable_class_name, permitted_params)
    )
    trackable_class = trackable_class_name.constantize
    trackable_id_key = "#{trackable_class_name.downcase}_id".to_sym
    removed_trackables.each do |t|
      trackable_usage = TrackableUsage.find_by(
        user: current_user,
        trackable: trackable_class.find(t[trackable_id_key])
      )

      next if trackable_usage.blank?

      if trackable_usage.count.eql?(1)
        trackable_usage.destroy
      else
        trackable_usage.decrement! :count
      end
    end
  end

  def removed_trackables_attrs(trackables_attrs)
    trackables_attrs.select { |attrs| attrs[:_destroy].eql?("1") }
  end

  def trackables_attrs(trackable_class_name, params)
    attrs_key = "#{trackable_class_name.downcase.pluralize}_attributes".to_sym
    trackables_attrs = params[attrs_key]

    return [] if trackables_attrs.blank?

    trackables_attrs
  end

  # For trackables that have been added to checkin, look for TrackableUsage records
  # for the current user. When a record exists its count is incremented,
  # else a new record is created
  def update_added_trackables_usages(trackable_class_name)
    added_trackables = added_trackables_attrs(
      trackables_attrs(trackable_class_name, permitted_params)
    )
    trackable_class = trackable_class_name.constantize
    trackable_id_key = "#{trackable_class_name.downcase}_id".to_sym
    added_trackables.each do |t|
      trackable = trackable_class.find(t[trackable_id_key])
      TrackableUsage.create_or_update_by(user: current_user, trackable: trackable)
    end
  end

  def added_trackables_attrs(trackables_attrs)
    trackables_attrs.select { |attrs| attrs[:id].blank? }
  end

  def update_health_factors_trackable_usages(trackable_class_name)
    trackable_class = trackable_class_name.constantize
    trackable_key = "#{trackable_class_name.downcase}_ids"

    trackable_class.where(id: permitted_params[trackable_key]).each do |health_factor|
      TrackableUsage.create_or_update_by(user: current_user, trackable: health_factor)
    end
  end
end
