require "rails_helper"
require "sidekiq/testing"

RSpec.describe Api::V1::ReactionsController do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:reacted_post) { create(:post, encrypted_user_id: author.encrypted_id) }

  let(:reaction_params) do
    {value: ":smile:", reactable_id: reacted_post.id.to_s, reactable_type: "post"}
  end

  before { sign_in user }

  around do |example|
    Sidekiq::Testing.fake! do
      UpdatePostCountersJob.clear
      example.run
    end
  end

  describe "create" do
    it "records the reaction" do
      expect { post :create, params: {reaction: reaction_params} }
        .to change { Reaction.count }.by(1)

      expect(response).to have_http_status :created
    end

    it "returns the aggregated tally for the reactable, not the bare record" do
      post :create, params: {reaction: reaction_params}

      body = response_body[:reaction]
      expect(body[:value]).to eq ":smile:"
      expect(body[:count]).to eq 1
      expect(body[:participated]).to be true
      expect(body[:reactable_id]).to eq reacted_post.id.to_s
      expect(body[:reactable_type]).to eq "Post"
    end

    it "counts other people's matching reactions in the tally" do
      create(:reaction, value: ":smile:", reactable: reacted_post, encrypted_user_id: author.encrypted_id)

      post :create, params: {reaction: reaction_params}

      expect(response_body[:reaction][:count]).to eq 2
    end

    it "notifies the author of the post" do
      expect { post :create, params: {reaction: reaction_params} }
        .to change { Notification.count }.by(1)
    end

    it "enqueues a counter refresh for the reactable" do
      post :create, params: {reaction: reaction_params}

      expect(UpdatePostCountersJob.jobs.size).to eq 1
    end

    context "when reacting to your own post" do
      let(:reacted_post) { create(:post, encrypted_user_id: user.encrypted_id) }

      it "does not notify anybody" do
        expect { post :create, params: {reaction: reaction_params} }
          .not_to change { Notification.count }
      end
    end

    context "when the same user reacts twice with the same value" do
      it "reuses the existing reaction rather than duplicating it" do
        post :create, params: {reaction: reaction_params}

        expect { post :create, params: {reaction: reaction_params} }
          .not_to change { Reaction.count }
      end
    end
  end

  describe "destroy" do
    let!(:reaction) do
      create(:reaction, value: ":smile:", reactable: reacted_post, encrypted_user_id: user.encrypted_id)
    end

    it "removes the reaction and returns 204" do
      expect {
        delete :destroy, params: {id: reaction.id.to_s, reaction: reaction_params}
      }.to change { Reaction.count }.by(-1)

      expect(response).to have_http_status :no_content
    end

    it "enqueues a counter refresh" do
      delete :destroy, params: {id: reaction.id.to_s, reaction: reaction_params}

      expect(UpdatePostCountersJob.jobs.size).to eq 1
    end

    context "when the reaction belongs to somebody else" do
      let!(:reaction) do
        create(:reaction, value: ":smile:", reactable: reacted_post, encrypted_user_id: author.encrypted_id)
      end

      # The lookup is scoped to the current user, so another user's reaction is not
      # found at all; `authorize!` is then called on nil and refuses.
      it "is refused and removes nothing" do
        expect {
          delete :destroy, params: {id: reaction.id.to_s, reaction: reaction_params}
        }.not_to change { Reaction.count }

        expect(response.status).to eq 401
      end
    end
  end
end
