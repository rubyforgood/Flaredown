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
    @profiles = @profiles.search_by_slug_name(params[:query]) if params[:query].present?
    render json: @profiles.map { |profile| profile.attributes.slice("screen_name", "slug_name") }
  end

  def show
    render json: @profile
  end

  def update
    @profile.update_attributes!(update_params)
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
      ethnicity_ids: []
    )
  end
end
