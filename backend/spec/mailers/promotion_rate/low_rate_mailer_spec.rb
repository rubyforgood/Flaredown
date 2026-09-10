require "rails_helper"

# Reached only from `rake oneoff:send_promotion_rate_low_rate`, which stringifies every
# value before handing it to the view. The examples use the same shape that task
# produces rather than model instances.
RSpec.describe PromotionRate::LowRateMailer, type: :mailer do
  # ApplicationMailer captures the From address into default_params at class load, so
  # stubbing the config it reads would be too late. Override the stored default instead.
  before do
    allow(described_class).to receive(:default_params)
      .and_return(described_class.default_params.merge(from: "from@some.email"))
  end

  let(:start_date) { "17-09-2017" }
  let(:end_date) { "22-09-2017" }
  let(:objects) do
    [{"_id" => "1", "score" => "2", "feedback" => "rough week", "date" => "2017-09-18"}]
  end
  let(:mail) { described_class.show("ops@flaredown.com", objects, start_date, end_date) }

  it "renders the headers" do
    expect(mail.subject).to eq I18n.t("promotion_rate.low_rate.subject")
    expect(mail.to).to eq ["ops@flaredown.com"]
    expect(mail.from).to eq ["from@some.email"]
  end

  it "shows the date range" do
    expect(mail.body.encoded).to include "#{start_date} - #{end_date}"
  end

  it "shows the score, the feedback and the date" do
    body = mail.body.encoded

    expect(body).to include "rough week"
    expect(body).to match(/Score:\s*2/)
    expect(body).to include "2017-09-18"
  end
end
