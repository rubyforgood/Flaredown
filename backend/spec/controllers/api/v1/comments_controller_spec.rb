require "rails_helper"
require "sidekiq/testing"

RSpec.describe Api::V1::CommentsController do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:commented_post) { create(:post, encrypted_user_id: author.encrypted_id) }

  around do |example|
    Sidekiq::Testing.fake! do
      UpdatePostCountersJob.clear
      DiscussionMention.clear
      example.run
    end
  end

  describe "index" do
    let!(:first) { create(:comment, post_id: commented_post.id, body: "first") }
    let!(:second) { create(:comment, post_id: commented_post.id, body: "second") }

    it "returns only the requested comments, oldest first" do
      get :index, params: {ids: [second.id.to_s, first.id.to_s]}

      expect(response_body[:comments].map { |c| c[:body] }).to eq %w[first second]
    end

    it "is readable without signing in" do
      get :index, params: {ids: [first.id.to_s]}

      expect(response).to have_http_status :ok
    end

    # `ids` is not optional: it goes straight into `:id.in`, and Mongo rejects a null
    # there rather than treating it as "match nothing".
    it "fails rather than returning everything when no ids are given" do
      expect { get :index }.to raise_error(Mongo::Error::OperationFailure)
    end
  end

  # Post and Comment both `store_in collection: "postables"` without being an STI pair,
  # so a bare `Comment.count` counts posts too. Scope by `_type` or creating a post looks
  # like creating a comment.
  describe "create" do
    let(:attributes) { {body: "Hope today is gentler.", post_id: commented_post.id.to_s} }

    before { sign_in user }

    it "creates the comment against the signed-in user" do
      expect { post :create, params: {comment: attributes} }
        .to change { Comment.where(_type: "Comment").count }.by(1)

      expect(response).to have_http_status :created
      expect(Comment.find(response_body[:comment][:id]).encrypted_user_id).to eq user.encrypted_id
    end

    # Regression guard. These arguments used to be a symbol-keyed Hash, which Sidekiq 7
    # rejects outright -- the comment saved and then the enqueue raised, so the caller
    # got an error back for a comment that had in fact been created.
    it "enqueues the counter refresh with JSON-safe arguments" do
      post :create, params: {comment: attributes}

      expect(UpdatePostCountersJob.jobs.size).to eq 1
      expect(UpdatePostCountersJob.jobs.first["args"])
        .to eq [{"parent_id" => commented_post.id.to_s, "parent_type" => "Post"}]
    end

    it "enqueues the mention scan" do
      post :create, params: {comment: attributes}

      expect(DiscussionMention.jobs.size).to eq 1
    end

    it "notifies the post's author" do
      expect { post :create, params: {comment: attributes} }
        .to change { Notification.count }.by(1)
    end

    context "when commenting on your own post" do
      let(:commented_post) { create(:post, encrypted_user_id: user.encrypted_id) }

      it "does not notify anybody" do
        expect { post :create, params: {comment: attributes} }
          .not_to change { Notification.count }
      end
    end

    context "with a blank body" do
      let(:attributes) { {body: "", post_id: commented_post.id.to_s} }

      it "returns 422 and enqueues nothing" do
        expect { post :create, params: {comment: attributes} }
          .not_to change { Comment.where(_type: "Comment").count }

        expect(response).to have_http_status :unprocessable_entity
        expect(UpdatePostCountersJob.jobs).to be_empty
      end
    end

    context "when not signed in" do
      before { sign_out user }

      it "returns 302 and creates nothing" do
        expect { post :create, params: {comment: attributes} }
          .not_to change { Comment.where(_type: "Comment").count }

        expect(response.status).to eq 302
      end
    end
  end

  describe "show" do
    let!(:comment) { create(:comment, post_id: commented_post.id) }

    before { sign_in user }

    it "returns the requested comment" do
      get :show, params: {id: comment.id.to_s}

      expect(response_body[:comment][:id]).to eq comment.id.to_s
      expect(response_body[:comment][:body]).to eq comment.body
    end

    # `show` is not in the `skip_before_action` list that `index` is in.
    it "requires signing in, unlike index" do
      sign_out user

      get :show, params: {id: comment.id.to_s}

      expect(response.status).to eq 302
    end
  end
end
