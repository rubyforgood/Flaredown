require "rails_helper"

# Reached only from `rake oneoff:send_promotion_rate_statistic`, which hands the output
# of `PromotionRate.group_by_score_and_date` straight to the view -- string-keyed
# hashes, not model instances. The examples use the same shape that task produces.
RSpec.describe PromotionRate::StatisticMailer, type: :mailer do
  # ApplicationMailer captures the From address into default_params at class load, so
  # stubbing the config it reads would be too late. Override the stored default instead.
  before do
    allow(described_class).to receive(:default_params)
      .and_return(described_class.default_params.merge(from: "from@some.email"))
  end

  let(:start_date) { "17-09-2017" }
  let(:end_date) { "22-09-2017" }
  let(:objects) { [{"_id" => 3, "count" => 7}, {"_id" => 1, "count" => 2}] }
  let(:mail) { described_class.show("ops@flaredown.com", objects, start_date, end_date) }

  it "renders the headers" do
    expect(mail.subject).to eq I18n.t("promotion_rate.statistic.subject")
    expect(mail.to).to eq ["ops@flaredown.com"]
    expect(mail.from).to eq ["from@some.email"]
  end

  it "shows the date range and each score with its tally" do
    body = mail.body.encoded

    expect(body).to include "#{start_date} - #{end_date}"
    expect(body).to include "Amount:"
    expect(body).to match(/Score:\s*1/)
    expect(body).to match(/Score:\s*3/)
  end

  it "orders the scores ascending regardless of the order given" do
    scores = mail.body.encoded.scan(/Score:\s*(\d+)/).flatten

    expect(scores).to eq %w[1 3]
  end
end
