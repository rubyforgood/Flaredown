require "rails_helper"

describe DataExportJob do
  include ActiveJob::TestHelper

  let(:tag) { create :tag }
  let(:mail) { double }
  let(:food) { create :food }
  let(:user) { create :user }
  let(:checkin) { create :checkin, user_id: user.id, tag_ids: [tag.id], food_ids: [food.id] }
  let(:perform_now) { perform_enqueued_jobs { described_class.perform_later(user.id) } }

  context "base functionality" do
    let(:checkin_treatment) { create :checkin_treatment, checkin_id: checkin.id, value: "1mg", is_taken: true }
    let(:expected_csv) do
      csv = "Date,#{Treatment.find(checkin_treatment.treatment_id).name},Tags,Foods,Weather summary,Weather max temperature,Weather min temperature,Weather pressure,Weather precipitation intensity,Weather humidity\n"

      csv << "#{checkin.date},#{checkin_treatment.value},#{tag.name},#{food.long_desc},,,,,,\n"
    end

    it "passes valid csv to mailer" do
      expect(UserDataMailer).to receive(:trackings_csv).with(user.email, expected_csv).and_return(mail)
      expect(mail).to receive(:deliver_later)

      perform_now
    end
  end

  context "creating CSV data" do
    context "with treatments" do
      let(:extra_headers) { "Tags,Foods,Weather summary,Weather max temperature,Weather min temperature,Weather pressure,Weather precipitation intensity,Weather humidity" }
      it "reports treatments with dosages" do
        ct = create :checkin_treatment, checkin_id: checkin.id, value: "1mg", is_taken: true

        expect(subject.csv_data(user)).to eq <<~CSV
          Date,#{Treatment.find(ct.treatment_id).name},#{extra_headers}
          #{checkin.date},#{ct.value},#{tag.name},#{food.long_desc},,,,,,
        CSV
      end

      it "reports treatments without dosages" do
        ct = create :checkin_treatment, checkin_id: checkin.id, value: nil, is_taken: true

        expect(subject.csv_data(user)).to eq <<~CSV
          Date,#{Treatment.find(ct.treatment_id).name},#{extra_headers}
          #{checkin.date},Taken,#{tag.name},#{food.long_desc},,,,,,
        CSV
      end

      it "reports missed treatments" do
        ct = create :checkin_treatment, checkin_id: checkin.id, value: nil, is_taken: false

        expect(subject.csv_data(user)).to eq <<~CSV
          Date,#{Treatment.find(ct.treatment_id).name},#{extra_headers}
          #{checkin.date},Not Taken,#{tag.name},#{food.long_desc},,,,,,
        CSV
      end

      it "reports sanely with unusual data" do
        # The UI should not allow this, but the data model does not prevent it
        ct = create :checkin_treatment, checkin_id: checkin.id, value: "1mg", is_taken: false

        expect(subject.csv_data(user)).to eq <<~CSV
          Date,#{Treatment.find(ct.treatment_id).name},#{extra_headers}
          #{checkin.date},Not Taken,#{tag.name},#{food.long_desc},,,,,,
        CSV
      end
    end
    context "with weather" do
      let(:extra_headers) { "Tags,Foods,Weather summary,Weather max temperature,Weather min temperature,Weather pressure,Weather precipitation intensity,Weather humidity" }
      it "includes weather data" do
        checkin.weather_id = FactoryBot.create(:weather).id
        checkin.save

        expect(subject.csv_data(user)).to eq <<~CSV
          Date,#{extra_headers}
          #{checkin.date},#{tag.name},#{food.long_desc},,1.5,1.5,1.5,1.5,1.5
        CSV
      end
    end
  end
end
