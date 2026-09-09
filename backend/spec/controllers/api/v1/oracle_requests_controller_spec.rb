require "rails_helper"

# The oracle is anonymous: nobody signs in, and a per-request token in the
# X-Oracle-Token header is the only thing tying a caller to their own submission.
RSpec.describe Api::V1::OracleRequestsController do
  let(:symptom) { create(:symptom) }
  let(:attributes) { {age: 42, symptom_ids: [symptom.id]} }

  describe "create" do
    it "records the request without anyone signing in" do
      expect { post :create, params: {oracle_request: attributes} }
        .to change { OracleRequest.count }.by(1)

      expect(response).to have_http_status :ok
    end

    it "mints a token and returns it, so the caller can come back to edit" do
      post :create, params: {oracle_request: attributes}

      token = response_body[:oracle_request][:token]
      expect(token).to be_present
      expect(OracleRequest.find(response_body[:oracle_request][:id]).token).to eq token
    end

    it "reuses a token supplied in the header rather than minting a new one" do
      request.headers["X-Oracle-Token"] = "caller-supplied-token"

      post :create, params: {oracle_request: attributes}

      expect(response_body[:oracle_request][:token]).to eq "caller-supplied-token"
    end
  end

  describe "update" do
    let!(:oracle_request) { create(:oracle_request, age: 30, token: "the-token") }

    it "accepts an edit from the holder of the token" do
      request.headers["X-Oracle-Token"] = "the-token"

      put :update, params: {id: oracle_request.id.to_s, oracle_request: {age: 31}}

      expect(response).to have_http_status :ok
      expect(oracle_request.reload.age).to eq 31
    end

    # `responce` is an Array field, so the oracle's answers come back as a list.
    it "records the oracle's answers and any correction" do
      request.headers["X-Oracle-Token"] = "the-token"

      put :update, params: {
        id: oracle_request.id.to_s,
        oracle_request: {responce: [{name: "Asthma", confidence: "0.8", correction: "Eczema"}]}
      }

      answer = oracle_request.reload.responce.first
      expect(answer["name"]).to eq "Asthma"
      expect(answer["correction"]).to eq "Eczema"
    end

    # The refusal branch renders `status: :unauthorised` -- the British spelling, which
    # is not one of Rack's status symbols -- so it raises ArgumentError instead of
    # answering 401. In production `ExceptionLogger`'s `rescue_from "Exception"` turns
    # that into a 422 quoting the invalid symbol. The edit is still correctly refused,
    # which is why this has gone unnoticed; only the status and message are wrong.
    it "refuses an edit from somebody without the token, but with the wrong status" do
      request.headers["X-Oracle-Token"] = "the-wrong-token"

      expect {
        put :update, params: {id: oracle_request.id.to_s, oracle_request: {age: 31}}
      }.to raise_error(ArgumentError, /unauthorised/)

      expect(oracle_request.reload.age).to eq 30
    end
  end

  describe "show" do
    let!(:oracle_request) { create(:oracle_request, age: 30, token: "the-token") }

    it "returns the request" do
      get :show, params: {id: oracle_request.id.to_s}

      expect(response_body[:oracle_request][:age]).to eq 30
    end

    # The plain serializer has no token attribute, so reading somebody else's request
    # does not hand over the credential that would let you edit it.
    it "does not disclose the token" do
      get :show, params: {id: oracle_request.id.to_s}

      expect(response_body[:oracle_request]).not_to have_key "token"
    end
  end
end
