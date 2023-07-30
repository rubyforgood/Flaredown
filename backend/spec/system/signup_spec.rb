require "system_spec_helper"

RSpec.describe "signup flow" do
  it "loads the root page" do
    visit "/"
    expect(page.title).to eq "Flaredown"
  end
end
