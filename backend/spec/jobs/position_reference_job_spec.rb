require "rails_helper"

# Called only from lib/tasks/oneoff.rake, which backfills positions for existing
# Checkin and Weather records -- hence the stringly-typed class name argument.
RSpec.describe PositionReferenceJob do
  let(:user) { create(:user) }

  context "for a check-in" do
    let(:checkin) { create(:checkin, user_id: user.id) }

    it "attaches a position for the postal code" do
      described_class.new.perform("Checkin", checkin.id.to_s, "55403")

      expect(checkin.reload.position_id).to eq Position.find_by(postal_code: "55403").id
    end

    it "creates the position when it is not already known" do
      expect { described_class.new.perform("Checkin", checkin.id.to_s, "55403") }
        .to change { Position.where(postal_code: "55403").count }.by(1)
    end

    it "reuses an existing position rather than duplicating it" do
      Position.find_or_create_by(postal_code: "55403")

      expect { described_class.new.perform("Checkin", checkin.id.to_s, "55403") }
        .not_to change { Position.where(postal_code: "55403").count }
    end
  end

  context "for a weather record" do
    let(:weather) { create(:weather) }

    it "attaches a position for the postal code" do
      described_class.new.perform("Weather", weather.id, "55403")

      expect(weather.reload.position_id).to eq Position.find_by(postal_code: "55403").id
    end
  end
end
