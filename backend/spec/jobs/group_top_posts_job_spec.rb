require "rails_helper"

RSpec.describe GroupTopPostsJob do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:profile) { user.profile }

  before { profile.update!(notify_top_posts: true) }

  def run
    described_class.new.perform(profile.notify_token)
  end

  it "mails the weekly top posts to the profile's user" do
    expect { run }.to have_enqueued_mail(TopPostsMailer, :notify)
  end

  it "does nothing when the profile has opted out" do
    profile.update!(notify_top_posts: false)

    expect { run }.not_to have_enqueued_mail(TopPostsMailer, :notify)
  end

  # Once SES tells us an address bounced or complained, we stop mailing it.
  it "does nothing when the address has already been rejected" do
    profile.update!(rejected_type: "bounce")

    expect { run }.not_to have_enqueued_mail(TopPostsMailer, :notify)
  end

  it "does nothing when the token matches no profile" do
    expect { described_class.new.perform("no-such-token") }
      .not_to have_enqueued_mail(TopPostsMailer, :notify)
  end
end
