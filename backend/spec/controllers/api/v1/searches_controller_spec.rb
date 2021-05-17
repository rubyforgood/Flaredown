require "rails_helper"

RSpec.describe Api::V1::SearchesController do
  before { I18n.default_locale = :en }

  let!(:user) { create(:user) }
  let!(:foods) { create_list(:food, 2) }
  let!(:conditions) { create_list(:condition, 2) }

  before { sign_in user }

  describe "show" do
    context "when searchable exists for the requested date" do
      let!(:condition_to_find) { create(:condition, name: "ACL injury") }

      it "returns correct searchables with first three letters" do
        get :show, params: {resource: "condition", query: {name: "ACL"}}
        expect_valid_responses(response_body)
      end

      def expect_valid_responses(response)
        expect(response[:search][:searchables].count).to eq 1
        expect(response[:search][:searchables][0][:type]).to eq "condition"
        expect(response[:search][:searchables][0][:name]).to eq "ACL injury"
      end
    end

    context "when food exists" do
      let!(:food_to_find) { create(:food, long_desc: "Banana") }

      before { get :show, params: {resource: "food", query: {name: "bana"}} }

      it "returns correct searchable food" do
        expect(response_body[:search][:searchables].count).to eq 1
        expect(response_body[:search][:searchables][0][:type]).to eq "food"
        expect(response_body[:search][:searchables][0][:name]).to eq "Banana"
      end
    end
  end
end
