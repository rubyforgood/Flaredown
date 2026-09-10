require "rails_helper"

RSpec.describe Api::V1::PostablesController do
  let(:user) { create(:user) }
  let(:stranger) { create(:user) }

  let!(:own_post) { create(:post, encrypted_user_id: user.encrypted_id) }
  let!(:own_comment) { create(:comment, encrypted_user_id: user.encrypted_id) }

  before { sign_in user }

  describe "index" do
    it "returns the user's own posts and comments" do
      get :index

      postables = response_body[:postables].first
      expect(postables[:post_ids]).to include own_post.id.to_s
      expect(postables[:comment_ids]).to include own_comment.id.to_s
    end

    it "excludes another user's postables" do
      their_post = create(:post, encrypted_user_id: stranger.encrypted_id)

      get :index

      postables = response_body[:postables].first
      expect(postables[:post_ids]).not_to include their_post.id.to_s
    end

    # A comment is only meaningful alongside the post it hangs off, so the serializer
    # pulls in parent posts the user did not write. They are sideloaded for context
    # but deliberately left out of `post_ids`.
    it "sideloads the parent post of a comment without listing it as the user's own" do
      parent_post_id = Comment.find(own_comment.id).post_id.to_s

      get :index

      expect(response_body[:posts].map { |p| p[:id] }).to include parent_post_id
      expect(response_body[:postables].first[:post_ids]).not_to include parent_post_id
    end

    it "emits sideloaded records through the Api::V1 serializers" do
      get :index

      sideloaded_post = response_body[:posts].first
      expect(sideloaded_post).to have_key "id"
      expect(sideloaded_post).not_to have_key "_id"
      expect(sideloaded_post["type"]).to eq "post"
      expect(sideloaded_post).to have_key "user_name"
    end

    # The raw document carries the Postgres/Mongo join key. Nothing outside the API needs
    # it, and it used to be handed to the client whenever this endpoint was called.
    it "does not expose encrypted_user_id on sideloaded records" do
      get :index

      expect(response_body[:posts].first).not_to have_key "encrypted_user_id"
      expect(response_body[:comments].first).not_to have_key "encrypted_user_id"
    end

    it "serializes the other sideloaded collections too" do
      tag = create(:tag)
      create(:post, encrypted_user_id: user.encrypted_id, tag_ids: [tag.id])

      get :index

      expect(response_body[:tags].first).to have_key "id"
      expect(response_body[:tags].first).not_to have_key "_id"
    end
  end
end
