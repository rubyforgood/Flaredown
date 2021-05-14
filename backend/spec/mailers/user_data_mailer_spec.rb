require "rails_helper"

describe UserDataMailer do
  describe "trackings_csv" do
    let(:mail) { UserDataMailer.trackings_csv(to_email, "header1,header2\nvalue1, value2\n") }
    let(:to_email) { "some@email.yo" }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("user_data_mailer.trackings_csv.subject"))
      expect(mail.to).to eq([to_email])
      expect(mail.from).to eq(["from@some.email"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("- The Flaredown Team")
    end

    it "has attachment" do
      expect(mail.attachments.count).to eq 1
      expect(mail.attachments.first.content_type).to eq "text/csv; filename=data.csv"
    end
  end
end
