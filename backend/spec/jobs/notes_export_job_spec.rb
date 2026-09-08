require "rails_helper"

RSpec.describe NotesExportJob do
  let(:user) { create(:user, email: "exporter@flaredown.com") }

  around do |example|
    with_env("SMTP_EMAIL_FROM" => "from@some.email") { example.run }
  end

  before { ActionMailer::Base.deliveries.clear }

  let(:mail) { ActionMailer::Base.deliveries.last }

  it "mails the user their check-in notes" do
    create(:checkin, user_id: user.id, note: "Bad flare today", date: 1.day.ago)

    described_class.new.perform(user.id)

    expect(mail.to).to eq [user.email]
    expect(mail.subject).to eq "Flaredown data export"
    expect(mail.body.encoded).to include "Bad flare today"
  end

  it "skips check-ins with no note" do
    create(:checkin, user_id: user.id, note: "", date: 1.day.ago)
    create(:checkin, user_id: user.id, note: nil, date: 2.days.ago)
    create(:checkin, user_id: user.id, note: "Only this one", date: 3.days.ago)

    described_class.new.perform(user.id)

    expect(mail.body.encoded.scan("Only this one").size).to eq 1
  end

  it "lists the most recent note first" do
    create(:checkin, user_id: user.id, note: "Older", date: 5.days.ago)
    create(:checkin, user_id: user.id, note: "Newer", date: 1.day.ago)

    described_class.new.perform(user.id)

    body = mail.body.encoded
    expect(body.index("Newer")).to be < body.index("Older")
  end

  it "still sends when the user has no notes" do
    described_class.new.perform(user.id)

    expect(mail.to).to eq [user.email]
  end
end
