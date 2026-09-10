require "rails_helper"

RSpec.describe Api::V1::PatternsController do
  let(:user) { create(:user) }
  let(:stranger) { create(:user) }

  let!(:own_pattern) { create(:pattern, encrypted_user_id: user.encrypted_id, name: "Flare week") }
  let!(:their_pattern) { create(:pattern, encrypted_user_id: stranger.encrypted_id, name: "Theirs") }

  before { sign_in user }

  describe "index" do
    it "returns only the signed-in user's patterns" do
      get :index

      names = response_body[:patterns].map { |p| p[:name] }
      expect(names).to eq ["Flare week"]
    end

    it "returns the requested patterns when ids are given, whoever owns them" do
      get :index, params: {pattern_ids: [their_pattern.id.to_s]}

      expect(response_body[:patterns].map { |p| p[:name] }).to eq ["Theirs"]
    end

    it "pages at ten per request" do
      create_list(:pattern, 10, encrypted_user_id: user.encrypted_id)

      get :index

      expect(response_body[:patterns].size).to eq 10
    end
  end

  describe "create" do
    let(:attributes) do
      {name: "Winter", includes: [{id: "1", category: "conditions", label: "Asthma"}]}
    end

    it "creates a pattern owned by the signed-in user" do
      expect { post :create, params: {pattern: attributes} }
        .to change { Pattern.count }.by(1)

      created = Pattern.find(response_body[:pattern][:id])
      expect(created.name).to eq "Winter"
      expect(created.encrypted_user_id).to eq user.encrypted_id
    end
  end

  describe "update" do
    it "renames the pattern" do
      put :update, params: {id: own_pattern.id.to_s, pattern: {name: "Renamed"}}

      expect(own_pattern.reload.name).to eq "Renamed"
    end

    it "refuses to touch somebody else's pattern" do
      put :update, params: {id: their_pattern.id.to_s, pattern: {name: "Renamed"}}

      expect(response.status).to eq 401
      expect(their_pattern.reload.name).to eq "Theirs"
    end
  end

  describe "destroy" do
    it "deletes the pattern and returns 204" do
      expect { delete :destroy, params: {id: own_pattern.id.to_s} }
        .to change { Pattern.count }.by(-1)

      expect(response).to have_http_status :no_content
    end

    it "refuses to delete somebody else's pattern" do
      expect { delete :destroy, params: {id: their_pattern.id.to_s} }
        .not_to change { Pattern.count }

      expect(response.status).to eq 401
    end
  end

  # `show` reads its id from `pattern_params`, which is `params.require(:pattern)` and
  # does not permit `:id` -- so a plain GET has no `pattern` key and fails the require,
  # and even supplying one yields a nil id. The action ignores the `@pattern` that
  # `load_and_authorize_resource` already loaded for it. Documented rather than fixed:
  # the clients do not call it, and repairing it is an API change.
  describe "show" do
    it "returns 422 for a plain request" do
      get :show, params: {id: own_pattern.id.to_s}

      expect(response).to have_http_status :unprocessable_entity
      expect(response_body[:errors]).to include "Required parameter missing: pattern"
    end

    it "returns 404 even when a pattern id is nested in the expected place" do
      get :show, params: {id: own_pattern.id.to_s, pattern: {id: own_pattern.id.to_s}}

      # `:id` is not in the permit list, so the lookup runs with a nil id and Mongoid
      # raises DocumentNotFound -- the pattern is there, the action just cannot see it.
      expect(response).to have_http_status :not_found
    end
  end
end
