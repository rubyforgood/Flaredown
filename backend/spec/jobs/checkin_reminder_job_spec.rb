require "rails_helper"
require "sidekiq/testing"

RSpec.describe CheckinReminderJob do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:profile) { user.profile }
  let(:reminder_at) { Time.zone.parse("09:00").iso8601 }

  around do |example|
    Sidekiq::Testing.fake! do
      described_class.clear
      example.run
    end
  end

  before { profile.update!(checkin_reminder: true, time_zone_name: "America/Chicago") }

  # The job only fires if its own jid is the one the profile is currently pointing at.
  # That is how a rescheduled reminder cancels the one it replaced: the stale job still
  # runs, sees a different id, and returns without mailing.
  def run_as_current_job
    job = described_class.new
    allow(job).to receive(:jid).and_return(profile.reminder_job_id)
    job.perform(profile.id, reminder_at)
  end

  it "mails the reminder when it is the scheduled job" do
    profile.update_column(:reminder_job_id, "current-job-id")

    expect { run_as_current_job }.to have_enqueued_mail(CheckinReminderMailer, :remind)
  end

  it "schedules the next day's reminder and takes over the job id" do
    profile.update_column(:reminder_job_id, "current-job-id")

    run_as_current_job

    expect(described_class.jobs.size).to eq 1
    expect(profile.reload.reminder_job_id).to eq described_class.jobs.first["jid"]
  end

  it "does nothing when a newer reminder has superseded this one" do
    profile.update_column(:reminder_job_id, "some-newer-job-id")
    job = described_class.new
    allow(job).to receive(:jid).and_return("this-stale-job-id")

    expect { job.perform(profile.id, reminder_at) }
      .not_to have_enqueued_mail(CheckinReminderMailer, :remind)
  end

  it "does nothing when the user has turned reminders off" do
    profile.update!(checkin_reminder: false)
    profile.update_column(:reminder_job_id, "current-job-id")

    expect { run_as_current_job }.not_to have_enqueued_mail(CheckinReminderMailer, :remind)
  end

  it "does nothing when the address has already been rejected" do
    profile.update!(rejected_type: "bounce")
    profile.update_column(:reminder_job_id, "current-job-id")

    expect { run_as_current_job }.not_to have_enqueued_mail(CheckinReminderMailer, :remind)
  end

  it "does nothing when the profile is gone" do
    expect { described_class.new.perform(-1, reminder_at) }
      .not_to have_enqueued_mail(CheckinReminderMailer, :remind)
  end
end
