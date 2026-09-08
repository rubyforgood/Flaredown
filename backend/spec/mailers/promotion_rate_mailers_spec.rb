require "rails_helper"

# Both of these are only ever invoked from rake tasks in lib/tasks/oneoff.rake, which
# pass aggregation output straight through -- string-keyed hashes, not model instances.
# The specs use the same shapes those tasks produce.
RSpec.describe "promotion rate mailers", type: :mailer do
  let(:start_date) { "17-09-2017" }
  let(:end_date) { "22-09-2017" }

  def stub_from(mailer)
    allow(mailer).to receive(:default_params)
      .and_return(mailer.default_params.merge(from: "from@some.email"))
  end

  describe PromotionRate::StatisticMailer do
    before { stub_from(described_class) }

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

  describe PromotionRate::LowRateMailer do
    before { stub_from(described_class) }

    let(:objects) do
      [{"_id" => "1", "score" => "2", "feedback" => "rough week", "date" => "2017-09-18"}]
    end
    let(:mail) { described_class.show("ops@flaredown.com", objects, start_date, end_date) }

    it "renders the headers" do
      expect(mail.subject).to eq I18n.t("promotion_rate.low_rate.subject")
      expect(mail.to).to eq ["ops@flaredown.com"]
    end

    it "shows the score, the feedback and the date" do
      body = mail.body.encoded

      expect(body).to include "rough week"
      expect(body).to match(/Score:\s*2/)
      expect(body).to include "2017-09-18"
    end
  end
end
