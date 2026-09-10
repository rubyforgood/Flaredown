require "rails_helper"

RSpec.describe Api::V1::DataExportSchedulesController do
  let(:user) { create(:user) }

  describe "create" do
    context "when no user logged-in" do
      it "returns 302 (redirect to sign-in) and schedules nothing" do
        expect(DataExportJob).not_to receive(:perform_later)

        post :create

        expect(response.status).to eq 302
      end
    end

    context "when user logged-in" do
      before { sign_in user }

      it "schedules the export for the current user and returns 201" do
        expect(DataExportJob).to receive(:perform_later).with(user.id)

        post :create

        expect(response).to have_http_status :created
        expect(response.body).to be_empty
      end
    end
  end
end
