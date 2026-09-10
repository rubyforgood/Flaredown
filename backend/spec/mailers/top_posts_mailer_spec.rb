require "rails_helper"

RSpec.describe TopPostsMailer, type: :mailer do
  # ApplicationMailer captures the From address into default_params at class load, so
  # stubbing the config it reads would be too late. Override the stored default instead.
  before do
    allow(described_class).to receive(:default_params)
      .and_return(described_class.default_params.merge(from: "from@some.email"))
  end

  let(:user) { create(:user, email: "reader@flaredown.com") }
  let(:top_post) { create(:post, title: "A very good week") }

  let(:mail) do
    described_class.notify(
      email: user.email,
      notify_token: "tok123",
      top_posts_ids: [top_post.id.to_s]
    )
  end

  it "renders the headers" do
    expect(mail.subject).to eq 'Weekly "top posts"'
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ["from@some.email"]
  end

  it "lists the top posts" do
    expect(mail.body.encoded).to include "A very good week"
  end

  it "includes an unsubscribe link scoped to top posts only" do
    expect(mail.body.encoded).to include "/unsubscribe/tok123"
    expect(mail.body.encoded).to include "notify_top_posts=false"
  end

  # `valid_email?` returns nil for a malformed address and the action returns early, so
  # no message is produced at all rather than one being sent somewhere useless.
  it "sends nothing when the address is not a valid email" do
    mail = described_class.notify(email: "not-an-email", notify_token: "tok", top_posts_ids: [])

    expect(mail.message).to be_a ActionMailer::Base::NullMail
  end
end
