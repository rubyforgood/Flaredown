require "rails_helper"

RSpec.describe Api::V1::PromotionRatesController do
  let(:user) { create(:user) }
  let(:checkin) { create(:checkin, user_id: user.id, date: Time.zone.today) }

  before { sign_in user }

  describe "create" do
    it "records the rating against the check-in" do
      expect {
        post :create, params: {promotion_rate: {checkin_id: checkin.id.to_s, score: 9}}
      }.to change { PromotionRate.count }.by(1)

      expect(response_body[:promotion_rate][:score]).to eq 9
    end

    context "when the check-in belongs to somebody else" do
      let(:checkin) { create(:checkin, user_id: create(:user).id, date: Time.zone.today) }

      it "is refused and records nothing" do
        expect {
          post :create, params: {promotion_rate: {checkin_id: checkin.id.to_s, score: 9}}
        }.not_to change { PromotionRate.count }

        expect(response.status).to eq 401
      end
    end
  end

  describe "update" do
    let!(:promotion_rate) { PromotionRate.create!(checkin_id: checkin.id, score: 5) }

    it "updates the score and feedback" do
      put :update, params: {
        id: promotion_rate.id.to_s,
        promotion_rate: {checkin_id: checkin.id.to_s, score: 2, feedback: "rough week"}
      }

      expect(promotion_rate.reload.score).to eq 2
      expect(promotion_rate.reload.feedback).to eq "rough week"
    end

    # The controller stamps the rating with when the rater signed up, so responses can
    # be read against how long someone has been using the app.
    it "stamps the rating with the user's signup date" do
      put :update, params: {
        id: promotion_rate.id.to_s,
        promotion_rate: {checkin_id: checkin.id.to_s, score: 2}
      }

      # The field is a Date, so the timestamp is truncated on the way in.
      expect(promotion_rate.reload.user_created_at).to eq user.created_at.to_date
    end
  end

  describe "show" do
    let!(:promotion_rate) { PromotionRate.create!(checkin_id: checkin.id, score: 5) }

    it "returns the rating" do
      get :show, params: {id: promotion_rate.id.to_s}

      expect(response_body[:promotion_rate][:score]).to eq 5
    end
  end
end
