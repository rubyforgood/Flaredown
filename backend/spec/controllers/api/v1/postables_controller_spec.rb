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

      expect(response_body[:posts].map { |p| p[:_id] }).to include parent_post_id
      expect(response_body[:postables].first[:post_ids]).not_to include parent_post_id
    end

    # Documents current behaviour rather than endorsing it. PostableSerializer builds its
    # sideloads with a bare `ActiveModel::ArraySerializer`, which resolves a serializer by
    # unqualified class name -- it looks for `PostSerializer`, but this app defines
    # `Api::V1::PostSerializer`. AMS finds nothing and falls back to `DefaultSerializer`,
    # i.e. the raw Mongoid document. So these records are emitted with `_id` instead of
    # `id`, without the serializer's `type`/`user_name`/`priority`, and with
    # `encrypted_user_id` exposed. Passing `namespace:` or `each_serializer:` would fix it,
    # but that changes the payload shape for both clients, so it is left alone here.
    it "emits sideloaded records as raw documents, not through Api::V1 serializers" do
      get :index

      sideloaded_post = response_body[:posts].first
      expect(sideloaded_post).to have_key "_id"
      expect(sideloaded_post).to have_key "encrypted_user_id"
      expect(sideloaded_post).not_to have_key "type"
    end
  end
end
