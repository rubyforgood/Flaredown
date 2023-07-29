require "system_spec_helper"

RSpec.describe "signup flow" do
  it "loads the root page" do
    visit "/login"
    click_on "Signup Now"
    expect(page).to have_content("Create your Flaredown account")
    fill_in "Enter your email", with: "text@example.com"
    fill_in "Enter a secure password", with: "password123"
    fill_in "Enter a username", with: "example"
    # select "2000", :from => ".birthDate"
    x = find('.birthDate').click
    $stdin.gets
    # option = 'data-ebd-id="ember537-trigger"'
    
    # fill_in "Year", with: "2000"
    # fill_in "Month", with: "1"
    # fill_in "Day", with: "1"
    click_on ".checkbox"
    click_on ".g-recaptcha"
    click_on "Create Account"
    expect(page).to have_content("Create an account to get started")
  end
end
