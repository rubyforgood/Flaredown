require "rails_helper"

describe Reaction do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:encrypted_user_id) }
  end

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context "#values_count_with_participated" do
    it "should indicate counts and when the given user has already used the requested reaction" do
      reaction = create(:reaction, encrypted_user_id: user.encrypted_id, value: ":smile:")
      create(:reaction, encrypted_user_id: other_user.encrypted_id, value: ":smile:")
      create(:reaction, encrypted_user_id: other_user.encrypted_id, value: ":smirk:")

      expect(subject.class.values_count_with_participated(user.encrypted_id)).to match_array([
        hash_including({
          # A real reaction ID is only required/meaningful when the current user has reacted.
          # Otherwise the value is meaningless.
          id: reaction.id.to_s,
          value: ":smile:",
          count: 2,
          participated: true
        }),
        hash_including({
          # id is not relevant here because the user did not react
          value: ":smirk:",
          count: 1,
          participated: false
        })
      ])
    end

    it "should work with a filtered set" do
      create(:reaction, encrypted_user_id: user.encrypted_id)
      create(:reaction, encrypted_user_id: other_user.encrypted_id)
      create(:reaction, encrypted_user_id: other_user.encrypted_id, value: ":smirk:")

      filtered = Reaction.where(value: ":smirk:")

      expect(filtered.values_count_with_participated(user.encrypted_id)).to match([
        hash_including({
          value: ":smirk:",
          count: 1,
          participated: false
        })
      ])
    end
  end
end
