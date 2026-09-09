# == Schema Information
#
# Table name: trackings
#
#  id             :integer          not null, primary key
#  end_at         :date
#  start_at       :date
#  trackable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  color_id       :integer
#  trackable_id   :integer
#  user_id        :integer
#
# Indexes
#
#  index_trackings_on_trackable_type                   (trackable_type)
#  index_trackings_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_trackings_on_user_id                          (user_id)
#  index_trackings_unique_trackable                    (user_id,trackable_id,trackable_type,start_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Tracking, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:trackable) }
    it { is_expected.to validate_inclusion_of(:trackable_type).in_array(%w[Condition Symptom Treatment]) }

    context "without foreign key checks" do
      subject { create :tracking, :for_condition, :active }

      before { disable_foreign_key_checks("trackings") }
      after { enable_foreign_key_checks("trackings") }

      it do
        is_expected.to(
          validate_uniqueness_of(:user_id)
            .scoped_to([:trackable_id, :trackable_type, :start_at])
            .with_message("is already tracking this trackable")
        )
      end
    end
  end

  describe "ensure_color_id" do
    context "when have a parent" do
      let(:parent) { create(:tracking, :for_condition, :inactive) }

      subject { create(:tracking, :active, trackable: parent.trackable, user: parent.user) }

      it "has the same color previous Tracking" do
        expect(subject.color_id).to be_equal(parent.color_id)
      end
    end

    context "when have a nil color" do
      subject { create(:tracking, :active, :for_condition) }

      it "has the random color" do
        expect(subject.color_id).to be_present
      end
    end

    context "when have a color" do
      subject { create(:tracking, :active, :for_condition, color_id: 10) }

      it "has the assigned color" do
        expect(subject.color_id).to be_equal(10)
      end
    end
  end
end
