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

    it "returns a list of discussion posts filtered by post type" do
      post = create(:post, user_id: user.id)
      create(:post, user_id: other_user.id)
      symptom = post.symptom_ids

      get :index, params: { id: symptom[0], type: 'symptom' }

      expect(response_body[:posts].size).to eq 1
    end

    it "returns a list of discussion posts filtered by topic followings" do
      post = create(:post, user_id: user.id)
      create(:post, user_id: user.id)
      create(:post, user_id: user.id)
      topic_user_is_following = user.topic_following
      topic_user_is_following.symptom_ids = post.symptom_ids
      topic_user_is_following.save

      get :index, params: { following: true }

      expect(response_body[:posts].size).to eq 1
    end
  end
end
