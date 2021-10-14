require "rails_helper"

RSpec.describe Api::V1::PostsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "index" do
    it "returns a list of discussion posts" do
      create(:post, user_id: user.id)
      create(:post, user_id: other_user.id)
      get :index
      expect(response_body[:posts].size).to eq 2
    end
  end
end
