require "rails_helper"

RSpec.describe UpdatePostCountersJob do
  let(:parent_post) { create(:post) }

  # Arguments arrive from Redis as JSON, so the keys are always strings by the time
  # perform sees them, whatever the caller wrote.
  def run(parent_id:, parent_type: "Post")
    described_class.new.perform("parent_id" => parent_id.to_s, "parent_type" => parent_type)
  end

  it "recounts the post's comments" do
    create(:comment, post_id: parent_post.id)
    parent_post.update(comments_count: 0)

    run(parent_id: parent_post.id)

    expect(parent_post.reload.comments_count).to eq 1
  end

  it "ignores a parent type it does not handle" do
    expect { run(parent_id: parent_post.id, parent_type: "Comment") }
      .not_to change { parent_post.reload.comments_count }
  end

  # The `return unless post` guard below the lookup is unreachable: Mongoid's `find_by`
  # raises rather than returning nil, unlike Active Record's. So a post deleted between
  # the enqueue and the run makes the job raise and Sidekiq retry it to exhaustion, when
  # the author's guard says the intent was to shrug and move on. Documented rather than
  # changed, because the retry is only noise, not data loss.
  it "raises rather than shrugging when the post no longer exists" do
    expect { run(parent_id: BSON::ObjectId.new) }
      .to raise_error(Mongoid::Errors::DocumentNotFound)
  end
end
