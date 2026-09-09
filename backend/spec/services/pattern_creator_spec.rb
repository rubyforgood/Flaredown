require "rails_helper"

RSpec.describe PatternCreator do
  let(:user) { create(:user) }
  let(:includes) { [{"id" => 1, "category" => "conditions", "label" => "Asthma"}] }

  def build(overrides = {})
    described_class.new({name: "Flare week", user_id: user.id, includes: includes}.merge(overrides))
  end

  describe "#create" do
    it "creates the pattern with the given name and includes" do
      pattern = build.create

      expect(pattern).to be_persisted
      expect(pattern.name).to eq "Flare week"
      expect(pattern.includes.first["label"]).to eq "Asthma"
    end

    it "stores the owner encrypted rather than as a plain id" do
      pattern = build.create

      expect(pattern.encrypted_user_id).not_to eq user.id.to_s
      expect(SymmetricEncryption.decrypt(pattern.encrypted_user_id).to_i).to eq user.id
    end

    it "persists the start and end dates it was given" do
      start_at = 3.days.ago.to_date.to_s
      end_at = Date.current.to_s

      pattern = build(start_at: start_at, end_at: end_at).create

      expect(pattern.start_at.to_date).to eq start_at.to_date
      expect(pattern.end_at.to_date).to eq end_at.to_date
    end

    it "leaves the dates unset when none are given" do
      pattern = build.create

      expect(pattern.start_at).to be_nil
      expect(pattern.end_at).to be_nil
    end

    it "raises when the user cannot be found" do
      expect { build(user_id: -1).create }.to raise_error(NoMethodError)
    end
  end
end
