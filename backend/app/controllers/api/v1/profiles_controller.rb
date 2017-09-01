class Api::V1::ProfilesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: [:index]

  def index
    post = Post.find(params[:post_id])

    encrypted_user_ids =
      (post.comments.distinct(:encrypted_user_id) << post.encrypted_user_id).uniq.map do |encrypted_id|
        SymmetricEncryption.decrypt(encrypted_id)
      end

    @profiles = Profile.where(user_id: encrypted_user_ids).where.not(slug_name: nil)
    render json: @profiles.map { |profile| profile.attributes.slice("screen_name", "slug_name") }
  end

  def show
    render json: @profile
  end

  def update
    @profile.assign_attributes(update_params.merge(transform_hash_time))

    if @profile.checkin_reminder_at_changed? && @profile.valid?
      CheckinReminderJob.perform_in(get_reminder_time.minutes, @profile.id, @profile.checkin_reminder_at)
    end

    @profile.save!

    current_user.profile.reload
    set_locale
    render json: @profile
  end

  private

  def update_params
    params.require(:profile).permit(
      :country_id, :birth_date, :sex_id, :onboarding_step_id,
      :day_habit_id, :education_level_id, :day_walking_hours,
      :pressure_units, :temperature_units, :screen_name, :notify,
      :checkin_reminder, ethnicity_ids: []
    )
  end

  def transform_hash_time
    user_time = params.require(:profile)[:checkin_reminder_at].values.join(':')

    checkin_reminder_at =
      if(@profile.position && @profile.time_zone_name.present?)
        user_time.in_time_zone(@profile.time_zone_name).utc
      else
        user_time.to_time(:utc)
      end

    { checkin_reminder_at: checkin_reminder_at }
  end

  def get_reminder_time
    current_time_zone = Time.zone.name
    Time.zone = @profile.time_zone_name

    diff_minutes = (@profile.checkin_reminder_at - Time.current).divmod(1.days)[1].divmod(1.minutes)[0] # Select minutes

    Time.zone = current_time_zone
    diff_minutes
  end
end
