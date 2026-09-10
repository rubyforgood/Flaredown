require "rails_helper"

RSpec.describe DiscussionMention do
  let(:author) { create(:user) }
  let(:mentioned) { create(:user) }
  let(:post_record) { create(:post) }

  before { mentioned.profile.update!(slug_name: "jamie") }

  def comment_saying(body)
    create(:comment, body: body, post_id: post_record.id, encrypted_user_id: author.encrypted_id)
  end

  it "notifies a mentioned user" do
    comment = comment_saying("thanks @jamie, that helped")

    expect { described_class.new.perform(author.encrypted_id, comment.id.to_s) }
      .to change { Notification.where(kind: "mention").count }.by(1)
  end

  it "addresses the notification to the mentioned user and credits the author" do
    comment = comment_saying("thanks @jamie")

    described_class.new.perform(author.encrypted_id, comment.id.to_s)

    notification = Notification.where(kind: "mention").first
    expect(notification.encrypted_user_id).to eq author.encrypted_id
    expect(SymmetricEncryption.decrypt(notification.encrypted_notify_user_id).to_i).to eq mentioned.id
  end

  it "notifies each distinct name once" do
    other = create(:user)
    other.profile.update!(slug_name: "alex")
    comment = comment_saying("@jamie @alex @jamie any ideas?")

    expect { described_class.new.perform(author.encrypted_id, comment.id.to_s) }
      .to change { Notification.where(kind: "mention").count }.by(2)
  end

  it "ignores names that match no profile" do
    comment = comment_saying("hello @nobody")

    expect { described_class.new.perform(author.encrypted_id, comment.id.to_s) }
      .not_to change { Notification.count }
  end

  it "does nothing when the comment mentions no one" do
    comment = comment_saying("just a plain comment")

    expect { described_class.new.perform(author.encrypted_id, comment.id.to_s) }
      .not_to change { Notification.count }
  end
end
