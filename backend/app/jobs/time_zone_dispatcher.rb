class TimeZoneDispatcher
  require 'sidekiq/api'
  include Sidekiq::Worker

  def perform(profile_id, enqueued_job_id)
    profile = Profile.find_by(id: profile_id)
    enqueued_job = find_enqueued_job_time(enqueued_job_id)
    enqueued_job_time = enqueued&.at

    if enqueued_job_time
      if(time_changed?(profile, enqueued_job_time) || !profile.reload.checkin_reminder)
        enqueued_job.delete

        job_id = perform_job_in_time_zone(profile) if profile.checkin_reminder
      end
    else
      job_id = perform_job_in_time_zone(profile)
    end

    profile.update_attributes(reminder_job_id: job_id) if job_id
  end

  protected

  def time_changed?(profile, enqueued_job_time)
    reminder_in_time_zone = profile.checkin_reminder_at.in_time_zone(profile.time_zone_name)
    job_in_time_zone = enqueued_job_time.in_time_zone(profile.time_zone_name)

    (reminder_in_time_zone.strftime("%H%M") <=> job_in_time_zone.strftime("%H%M")) != 0
  end

  def perform_job_in_time_zone(profile)
    current_time_zone = Time.zone.name
    Time.zone = profile.time_zone_name

    diff_minutes = (profile.checkin_reminder_at - Time.current).divmod(60)[0] # Select minutes

    if diff_minutes >= 0
      job_id = SendRemindMailerJob.perform_in(diff_minutes.minutes, profile.user.email)
    end

    Time.zone = current_time_zone
    job_id
  end

  def find_enqueued_job_time(reminder_job_id)
    Sidekiq::ScheduledSet.new.find_job(reminder_job_id)
  end
end
