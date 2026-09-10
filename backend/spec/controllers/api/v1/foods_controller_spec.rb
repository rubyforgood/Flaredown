require "rails_helper"

RSpec.describe Api::V1::FoodsController do
  let(:user) { create(:user) }
  let!(:food) { create(:food, long_desc: "Cheddar cheese") }

  before { sign_in user }

  describe "index" do
    it "returns the requested foods when ids are given" do
      get :index, params: {ids: [food.id]}

      expect(response_body[:foods].map { |f| f[:id] }).to eq [food.id]
    end

    # most_recent is derived from the user's own check-ins, not from their food list.
    it "returns foods from the user's recent check-ins for the most_recent scope" do
      create(:checkin, user_id: user.id, food_ids: [food.id])

      get :index, params: {scope: "most_recent"}

      expect(response_body[:foods].map { |f| f[:id] }).to include food.id
    end

    it "does not return foods from another user's check-ins" do
      create(:checkin, user_id: create(:user).id, food_ids: [food.id])

      get :index, params: {scope: "most_recent"}

      expect(response_body[:foods]).to be_blank
    end

    # CollectionRetriever accepts only :most_popular and :most_recent, and raises on
    # anything else rather than falling back.
    it "raises on a scope it does not recognise" do
      expect { get :index, params: {scope: "mine"} }.to raise_error(ArgumentError)
    end

    # Neither ids nor scope leaves `foods` nil, and the serializer renders that as an
    # empty payload rather than falling back to returning everything.
    it "returns an empty payload when given neither ids nor a scope" do
      get :index

      expect(response).to have_http_status :ok
      expect(response_body[:foods]).to be_blank
    end
  end

  describe "show" do
    it "returns the requested food" do
      get :show, params: {id: food.id}

      expect(response_body[:food][:id]).to eq food.id
    end
  end

  describe "create" do
    it "creates a personal food and tracks it for the user" do
      expect { post :create, params: {food: {name: "Sourdough"}} }
        .to change { Food.count }.by(1)

      created = Food.find(response_body[:food][:id])
      expect(created.long_desc).to eq "Sourdough"
      expect(created.global).to be false
    end
  end
end
