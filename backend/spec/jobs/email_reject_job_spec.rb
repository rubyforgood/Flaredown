require "rails_helper"

RSpec.describe EmailRejectJob do
  let(:user) { create(:user) }

  it "records the rejection type against the recipient's profile" do
    described_class.new.perform({"bounce" => [user.email]})

    expect(user.profile.reload.rejected_type).to eq "bounce"
  end

  it "marks every listed recipient" do
    other = create(:user)

    described_class.new.perform({"complaint" => [user.email, other.email]})

    expect(user.profile.reload.rejected_type).to eq "complaint"
    expect(other.profile.reload.rejected_type).to eq "complaint"
  end

  it "leaves unlisted users alone" do
    other = create(:user)

    described_class.new.perform({"bounce" => [user.email]})

    expect(other.profile.reload.rejected_type).to be_nil
  end

  it "does nothing when no address matches a user" do
    expect { described_class.new.perform({"bounce" => ["nobody@example.com"]}) }
      .not_to raise_error
  end
end
