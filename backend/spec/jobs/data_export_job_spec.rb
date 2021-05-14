require "rails_helper"

describe DataExportJob do
  include ActiveJob::TestHelper

  let(:tag) { create :tag }
  let(:mail) { double }
  let(:food) { create :food }
  let(:user) { create :user }
  let(:checkin) { create :checkin, user_id: user.id, tag_ids: [tag.id], food_ids: [food.id] }
  let(:perform_now) { perform_enqueued_jobs { described_class.perform_later(user.id) } }
  let(:checkin_treatment) { create :checkin_treatment, checkin_id: checkin.id }

  let!(:expected_csv) do
    csv = "Date,#{Treatment.find(checkin_treatment.treatment_id).name},Tags,Foods\n"

    csv << "#{checkin.date},#{checkin_treatment.value},#{tag.name},#{food.long_desc}\n"
  end

  it "passes valid csv to mailer" do
    expect(UserDataMailer).to receive(:trackings_csv).with(user.email, expected_csv).and_return(mail)
    expect(mail).to receive(:deliver_later)

    perform_now
  end
end
