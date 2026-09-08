require "rails_helper"

RSpec.describe Api::V1::ChartListsController do
  let(:user) { create(:user) }

  describe "show" do
    context "when no user logged-in" do
      it "returns 302 (redirect to sign-in)" do
        get :show

        expect(response.status).to eq 302
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "renders every payload section, even with nothing tracked" do
        get :show

        expect(response).to have_http_status :ok
        expect(response_body[:chart_list][:id]).to eq 1
        expect(response_body[:chart_list][:payload].keys).to match_array(
          %w[tags foods symptoms conditions treatments weathersMeasures harveyBradshawIndices]
        )
      end

      it "marks a tag from the most recent check-in as currently tracked" do
        tag = create(:tag)
        create(:checkin, user_id: user.id, tag_ids: [tag.id], date: Time.zone.now)

        get :show

        expect(response_body[:chart_list][:payload][:tags]).to include([tag.id, tag.name, true])
      end

      it "reports the weather measures as untracked when the check-in has no weather" do
        create(:checkin, user_id: user.id, date: Time.zone.now)

        get :show

        tracked_flags = response_body[:chart_list][:payload][:weathersMeasures].map(&:last)
        expect(tracked_flags).to all(be false)
      end

      it "only reports the signed-in user's trackables" do
        someone_else = create(:user)
        their_tag = create(:tag)
        create(:checkin, user_id: someone_else.id, tag_ids: [their_tag.id], date: Time.zone.now)

        get :show

        reported_tag_ids = response_body[:chart_list][:payload][:tags].map(&:first)
        expect(reported_tag_ids).not_to include their_tag.id
      end
    end
  end
end
