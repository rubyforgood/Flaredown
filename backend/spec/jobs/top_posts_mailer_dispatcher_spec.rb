require "rails_helper"
require "sidekiq/testing"

RSpec.describe TopPostsMailerDispatcher do
  around do |example|
    Sidekiq::Testing.fake! do
      GroupTopPostsJob.clear
      example.run
    end
  end

  let(:user) { create(:user) }
  let(:profile) { user.profile }

  # The dispatcher only runs on Tuesdays, and only for profiles whose local time is
  # within five minutes of TOP_POST_WEEKLY_TIME. That constant is read at class load,
  # so travel to a time that matches whatever it holds rather than trying to set it.
  def tuesday_at(time_string)
    Time.zone.parse("2026-09-08 #{time_string}")
  end

  before do
    profile.update!(notify_top_posts: true, time_zone_name: "UTC")
  end

  it "enqueues nothing on a day that is not Tuesday" do
    travel_to Time.zone.parse("2026-09-09 12:00") do # Wednesday
      described_class.new.perform
    end

    expect(GroupTopPostsJob.jobs).to be_empty
  end

  it "enqueues nothing for a profile whose local time is far from the send time" do
    travel_to tuesday_at("12:00") do
      stub_const("#{described_class}::TOP_POST_WEEKLY_TIME", "23:00")
      described_class.new.perform
    end

    expect(GroupTopPostsJob.jobs).to be_empty
  end

  it "enqueues one job per matching profile, keyed by notify token" do
    travel_to tuesday_at("12:00") do
      stub_const("#{described_class}::TOP_POST_WEEKLY_TIME", "12:02")
      described_class.new.perform
    end

    expect(GroupTopPostsJob.jobs.size).to eq 1
    expect(GroupTopPostsJob.jobs.first["args"]).to eq [profile.notify_token]
  end

  it "skips profiles that have opted out of the digest" do
    profile.update!(notify_top_posts: false)

    travel_to tuesday_at("12:00") do
      stub_const("#{described_class}::TOP_POST_WEEKLY_TIME", "12:02")
      described_class.new.perform
    end

    expect(GroupTopPostsJob.jobs).to be_empty
  end
end
