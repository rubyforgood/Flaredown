require "rails_helper"

RSpec.describe Api::V1::HarveyBradshawIndicesController do
  let(:user) { create(:user) }
  let(:checkin) { create(:checkin, user_id: user.id) }

  let(:attributes) do
    {
      checkin_id: checkin.id.to_s,
      stools: 3,
      well_being: 1,
      abdominal_mass: 0,
      abdominal_pain: 2,
      abscess: true
    }
  end

  before { sign_in user }

  describe "create" do
    it "creates the index for the check-in" do
      expect { post :create, params: {harvey_bradshaw_index: attributes} }
        .to change { HarveyBradshawIndex.count }.by(1)
    end

    # score is the four integer measures summed, plus one point per true boolean.
    it "scores it as the integer measures plus each flagged symptom" do
      post :create, params: {harvey_bradshaw_index: attributes}

      expect(response_body[:harvey_bradshaw_index][:score]).to eq 7
    end

    it "stamps the index with the check-in's date and user" do
      post :create, params: {harvey_bradshaw_index: attributes}

      index = HarveyBradshawIndex.find(response_body[:harvey_bradshaw_index][:id])
      expect(index.date).to eq checkin.date.to_date
      expect(index.encrypted_user_id).to eq checkin.encrypted_user_id
    end

    context "when the check-in belongs to somebody else" do
      let(:checkin) { create(:checkin, user_id: create(:user).id) }

      it "is refused and creates nothing" do
        expect { post :create, params: {harvey_bradshaw_index: attributes} }
          .not_to change { HarveyBradshawIndex.count }

        expect(response.status).to eq 401
      end
    end
  end

  describe "show" do
    let!(:index) do
      HarveyBradshawIndex.create!(attributes.merge(checkin_id: checkin.id))
    end

    it "returns the requested index" do
      get :show, params: {id: index.id.to_s}

      expect(response_body[:harvey_bradshaw_index][:id]).to eq index.id.to_s
    end

    context "when it belongs to somebody else" do
      let(:checkin) { create(:checkin, user_id: create(:user).id) }

      it "is refused" do
        get :show, params: {id: index.id.to_s}

        expect(response.status).to eq 401
      end
    end
  end
end
