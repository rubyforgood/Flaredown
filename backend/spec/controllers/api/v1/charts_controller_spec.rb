require "rails_helper"

RSpec.describe Api::V1::ChartsController do
  let(:user) { create(:user) }
  let(:start_at) { 7.days.ago.to_date.to_s }
  let(:end_at) { Date.current.to_s }

  before { sign_in user }

  describe "show" do
    it "renders a chart for the requested range" do
      get :show, params: {start_at: start_at, end_at: end_at}

      expect(response).to have_http_status :ok
    end

    it "includes the user's check-ins that fall inside the range" do
      checkin = create(:checkin, user_id: user.id, date: 2.days.ago)

      get :show, params: {start_at: start_at, end_at: end_at}

      expect(response.body).to include checkin.id.to_s
    end

    it "excludes check-ins outside the range" do
      outside = create(:checkin, user_id: user.id, date: 90.days.ago)

      get :show, params: {start_at: start_at, end_at: end_at}

      expect(response.body).not_to include outside.id.to_s
    end

    context "when the range is missing" do
      it "returns 422 with the validation errors" do
        get :show

        expect(response).to have_http_status :unprocessable_entity
        expect(response_body[:errors].keys).to include "start_at", "end_at"
      end
    end
  end
end
