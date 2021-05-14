require "rails_helper"

describe SwitchTrackableVisibility do
  include ActiveJob::TestHelper

  before(:all) do
    @condition = create(:condition, :personal)
    create_list(:trackable_usage,
      Flaredown.config.trackables_min_popularity - 1,
      trackable_type: @condition.class.to_s,
      trackable_id: @condition.id)
  end

  let!(:trackable_usage) { TrackableUsage.last }

  context "for #{Flaredown.config.trackables_min_popularity} amount of tracks switch topic to global" do
    before(:each) do
      create(:trackable_usage, trackable_type: @condition.class.to_s, trackable_id: @condition.id)
      SwitchTrackableVisibility.perform_now(trackable_usage.id)
    end

    it { expect(trackable_usage.trackable.reload.global?).to be true }
  end
end
