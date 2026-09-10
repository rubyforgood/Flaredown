require "rails_helper"

RSpec.describe Api::V1::ChartsPatternController do
  let(:user) { create(:user) }
  let!(:pattern) do
    create(:pattern,
      encrypted_user_id: user.encrypted_id,
      includes: [{category: "treatments"}])
  end

  let(:base_params) do
    {
      start_at: 7.days.ago.to_date.to_s,
      end_at: Date.current.to_s,
      offset: 0,
      pattern_ids: [pattern.id.to_s]
    }
  end

  before { sign_in user }

  describe "index" do
    it "returns chart data for each requested pattern" do
      get :index, params: base_params

      expect(response).to have_http_status :ok
      expect(response_body[:charts_pattern].size).to eq 1
      expect(response_body[:charts_pattern].first[:pattern_name]).to eq pattern.name
    end

    it "advertises the available colours in the metadata" do
      get :index, params: base_params

      expect(response_body[:meta][:color_ids]).to eq Flaredown::Colorable::IDS
    end

    it "returns nothing when no pattern ids are given" do
      get :index, params: base_params.except(:pattern_ids)

      expect(response_body[:charts_pattern]).to be_empty
    end

    it "is readable without signing in" do
      sign_out user

      get :index, params: base_params

      expect(response).to have_http_status :ok
    end

    # The offset widens the window backwards, and forwards too unless the range already
    # ends today -- a request ending today is left alone so it does not ask for the
    # future.
    it "widens the window backwards by the offset" do
      expect(ChartsPattern).to receive(:new)
        .with(hash_including(start_at: 10.days.ago.to_date.to_s))
        .and_call_original

      get :index, params: base_params.merge(start_at: 7.days.ago.to_date.to_s, offset: 3)
    end

    it "leaves an end date of today unshifted" do
      expect(ChartsPattern).to receive(:new)
        .with(hash_including(end_at: Date.current.to_s))
        .and_call_original

      get :index, params: base_params.merge(offset: 3)
    end

    it "shifts an end date in the past forwards by the offset" do
      end_date = 2.days.ago.to_date

      expect(ChartsPattern).to receive(:new)
        .with(hash_including(end_at: (end_date + 3.days).to_s))
        .and_call_original

      get :index, params: base_params.merge(end_at: end_date.to_s, offset: 3)
    end
  end
end
