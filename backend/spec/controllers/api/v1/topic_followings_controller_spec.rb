require "rails_helper"

RSpec.describe Api::V1::TopicFollowingsController do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }
  let(:symptom) { create(:symptom) }

  let!(:topic_following) do
    TopicFollowing.create!(encrypted_user_id: user.encrypted_id, tag_ids: [tag.id])
  end

  before { sign_in user }

  describe "show" do
    it "returns the followed topics" do
      get :show, params: {id: topic_following.id.to_s}

      expect(response).to have_http_status :ok
      expect(response.body).to include tag.id.to_s
    end

    context "when it belongs to somebody else" do
      let!(:topic_following) do
        TopicFollowing.create!(encrypted_user_id: create(:user).encrypted_id)
      end

      it "is refused" do
        get :show, params: {id: topic_following.id.to_s}

        expect(response.status).to eq 401
      end
    end
  end

  describe "update" do
    # The Mongoid field is a plain Array with no element type, so ids are stored exactly
    # as they arrived over the wire -- strings, not the integers the Postgres records
    # use. `Symptom.where(id: ["1"])` still resolves, so this is survivable, but a
    # caller comparing ids without casting will not get a match.
    it "replaces the followed topics with those supplied, storing ids as strings" do
      put :update, params: {
        id: topic_following.id.to_s,
        topic_following: {symptom_ids: [symptom.id]}
      }

      expect(response).to have_http_status :ok
      expect(topic_following.reload.symptom_ids).to eq [symptom.id.to_s]
    end

    # `update_params` merges the submitted topics over a set of empty arrays, so any
    # category left out of the request is cleared rather than left alone. Following a
    # symptom therefore unfollows every tag.
    it "clears the categories the request omits" do
      put :update, params: {
        id: topic_following.id.to_s,
        topic_following: {symptom_ids: [symptom.id]}
      }

      expect(topic_following.reload.tag_ids).to be_empty
    end

    # An empty hash is dropped from the params entirely, so `params.require` fails
    # rather than clearing the topics. Unfollowing everything means sending explicit
    # empty arrays, not an empty object.
    it "returns 422 and changes nothing when the topic hash is empty" do
      put :update, params: {id: topic_following.id.to_s, topic_following: {}}

      expect(response).to have_http_status :unprocessable_entity
      expect(response_body[:errors]).to include "Required parameter missing: topic_following"
      expect(topic_following.reload.tag_ids).to eq [tag.id]
    end

    context "when it belongs to somebody else" do
      let!(:topic_following) do
        TopicFollowing.create!(encrypted_user_id: create(:user).encrypted_id)
      end

      it "is refused and changes nothing" do
        put :update, params: {
          id: topic_following.id.to_s,
          topic_following: {symptom_ids: [symptom.id]}
        }

        expect(response.status).to eq 401
        expect(topic_following.reload.symptom_ids).to be_empty
      end
    end
  end
end
