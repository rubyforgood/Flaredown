require "rails_helper"

RSpec.describe SameTrackablesJob do
  # This job reports duplicates without changing anything -- MergeTrackables::Dispatcher
  # is the one that acts on them. Its return value is the array it builds.
  def run(options)
    described_class.new.perform(options)
  end

  it "reports both names when two trackables share one" do
    create(:condition, name: "Asthma")
    create(:condition, name: "asthma")

    result = run("trackable_type" => "condition", "translation" => "Asthma")

    expect(result.flatten).to contain_exactly("Asthma", "asthma")
  end

  it "reports nothing when the name is unique" do
    create(:condition, name: "Asthma")

    result = run("trackable_type" => "condition", "translation" => "Asthma")

    expect(result.compact).to be_empty
  end

  it "scans every translation when given no name" do
    create(:condition, name: "Asthma")
    create(:condition, name: "Asthma")
    create(:condition, name: "Eczema")

    result = run("trackable_type" => "condition")

    expect(result.flatten.uniq).to contain_exactly("Asthma")
  end

  it "changes nothing" do
    create(:condition, name: "Asthma")
    create(:condition, name: "asthma")

    expect { run("trackable_type" => "condition", "translation" => "Asthma") }
      .not_to change { Condition.count }
  end

  it "searches foods by long_desc" do
    create(:food, long_desc: "Cheddar cheese")
    create(:food, long_desc: "cheddar cheese")

    result = run("trackable_type" => "food", "translation" => "Cheddar cheese")

    expect(result.flatten).to contain_exactly("Cheddar cheese", "cheddar cheese")
  end
end
