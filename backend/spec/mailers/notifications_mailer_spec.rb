require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  # ApplicationMailer captures the From address into default_params at class load, so
  # stubbing the config it reads would be too late. Override the stored default instead.
  before do
    allow(described_class).to receive(:default_params)
      .and_return(described_class.default_params.merge(from: "from@some.email"))
  end

  let(:user) { create(:user, email: "reader@flaredown.com") }
  let(:notified_post) { create(:post, title: "A hard week") }

  # The shape GroupNotifiersPerUser passes in: post id => kind => count.
  let(:data) { {notified_post.id.to_s => {"comment" => 2, "reaction" => 1}} }
  let(:mail) { described_class.notify(email: user.email, data: data) }

  it "renders the headers" do
    expect(mail.subject).to eq "New response to your Flaredown message"
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ["from@some.email"]
  end

  it "titles and links the post the activity was on" do
    body = mail.body.encoded

    expect(body).to include "A hard week"
    expect(body).to include notified_post.id.to_s
  end

  it "pluralises each kind against its count" do
    body = mail.body.encoded

    expect(body).to include "2 comments"
    expect(body).to include "1 reaction"
  end

  it "includes an unsubscribe link carrying the user's notify token" do
    expect(mail.body.encoded).to include "/unsubscribe/#{user.notify_token}"
  end

  it "sends nothing when the address is not a valid email" do
    mail = described_class.notify(email: "not-an-email", data: {})

    expect(mail.message).to be_a ActionMailer::Base::NullMail
  end
end
