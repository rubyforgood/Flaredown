require "rails_helper"

describe Notification do
  let(:alice) { create(:user) }
  let(:bob) { create(:user) }

  let(:first_post) { create(:post) }
  let(:second_post) { create(:post) }

  let(:comment_for_first_post) { create(:comment, post: first_post) }
  let(:comment_for_second_post) { create(:comment, post: second_post) }

  context "#count_by_types" do
    it "should count all by kind" do
      # The following are valid possibilities for (kind, notificateable_type):
      # - ("comment", "Comment"): commenting on a post
      # - ("mention", "Comment"): users can only mention other users who have commented in a post
      # - ("reaction", "Post")
      # - ("reaction", "Comment")

      alice_id = alice.encrypted_id
      bob_id = bob.encrypted_id

      create(:notification, kind: "comment", notificateable: comment_for_first_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)
      create(:notification, kind: "comment", notificateable: comment_for_second_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)

      create(:notification, kind: "mention", notificateable: comment_for_first_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)
      create(:notification, kind: "mention", notificateable: comment_for_second_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)

      create(:notification, kind: "reaction", notificateable: first_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)
      create(:notification, kind: "reaction", notificateable: second_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)
      create(:notification, kind: "reaction", notificateable: comment_for_first_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)
      create(:notification, kind: "reaction", notificateable: comment_for_second_post, encrypted_user_id: alice_id, encrypted_notify_user_id: bob_id)

      expect(Notification.all.count_by_types).to eq({
        "comment" => 2,
        "mention" => 2,
        "reaction" => 4,
      })
    end
  end
end
