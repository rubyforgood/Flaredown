require "rails_helper"
require "sidekiq/testing"

RSpec.describe UpdateCheckinReminders do
  let(:user) { create(:user) }
  let(:profile) { user.profile }

  around do |example|
    Sidekiq::Testing.fake! do
      CheckinReminderJob.clear
      example.run
    end
  end

  before do
    profile.update!(
      checkin_reminder: true,
      checkin_reminder_at: Time.zone.parse("09:00"),
      time_zone_name: "America/Chicago"
    )
  end

  it "schedules a reminder and records its job id" do
    described_class.new.perform(profile.id)

    expect(CheckinReminderJob.jobs.size).to eq 1
    expect(profile.reload.reminder_job_id).to eq CheckinReminderJob.jobs.first["jid"]
  end

  # Regression guard. checkin_reminder_at is a datetime column, and Sidekiq 7 rejects
  # anything that is not a native JSON type, so passing the raw value raised here.
  it "passes the reminder time as a string rather than a datetime" do
    described_class.new.perform(profile.id)

    profile_id, reminder_at = CheckinReminderJob.jobs.first["args"]
    expect(profile_id).to eq profile.id
    expect(reminder_at).to be_a String
    expect(Time.zone.parse(reminder_at)).to eq profile.checkin_reminder_at
  end

  it "does nothing when the profile has opted out of reminders" do
    profile.update!(checkin_reminder: false)

    described_class.new.perform(profile.id)

    expect(CheckinReminderJob.jobs).to be_empty
  end

  it "does nothing when no reminder time is set" do
    profile.update!(checkin_reminder_at: nil)

    described_class.new.perform(profile.id)

    expect(CheckinReminderJob.jobs).to be_empty
  end

  it "does nothing when the profile does not exist" do
    expect { described_class.new.perform(-1) }
      .not_to change { CheckinReminderJob.jobs.size }
  end
end
