module Api
  module V1
    class ProfilesController < ApplicationController
      require "sidekiq/api"

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
        initial_onboarding_reminder = params.dig(:profile, :onboarding_reminder)

        @profile.assign_attributes(update_params.merge(transform_hash_time))
        time_changed = @profile.checkin_reminder_at_changed? || @profile.time_zone_name_changed?
        @profile.save!

        if time_changed || initial_onboarding_reminder
          delete_old_job(@profile.reminder_job_id)

          job_id = CheckinReminderJob.perform_in(get_reminder_time.minutes, @profile.id, @profile.checkin_reminder_at)
          @profile.update_column(:reminder_job_id, job_id)
        end

        current_user.profile.reload
        set_locale
        render json: @profile
      end

      private

      def update_params
        params.require(:profile).permit(
          :country_id, :sex_id, :onboarding_step_id, :birth_date,
          :day_habit_id, :education_level_id, :day_walking_hours,
          :pressure_units, :temperature_units, :screen_name, :notify,
          :checkin_reminder, :time_zone_name, :notify_top_posts, ethnicity_ids: []
        )
      end

      def transform_hash_time
        checkin_reminder_at = params.require(:profile)[:checkin_reminder_at]
        user_time = checkin_reminder_at && checkin_reminder_at.values.join(":")

        {checkin_reminder_at: user_time.try(:to_time, :utc)}
      end

      def get_reminder_time
        time_zone_name = @profile.time_zone_name
        checkin_at_timezone = @profile.checkin_reminder_at.strftime("%H:%M").in_time_zone(time_zone_name)

        # Select minutes
        (checkin_at_timezone - Time.current.in_time_zone(time_zone_name)).divmod(1.day)[1].divmod(1.minute)[0]
      end

      def delete_old_job(enqueued_job_id)
        Sidekiq::ScheduledSet.new.find_job(enqueued_job_id)&.delete
      end
    end
  end
end
