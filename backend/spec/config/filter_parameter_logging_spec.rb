require "rails_helper"

RSpec.describe "parameter filtering" do
  it "redacts submitted locations and derived coordinates from application logs" do
    filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

    location = {
      "postal_code" => "123 Main Street",
      "latitude" => 44.967486,
      "longitude" => -93.2897678
    }

    expect(filter.filter(location)).to eq(
      "postal_code" => "[FILTERED]",
      "latitude" => "[FILTERED]",
      "longitude" => "[FILTERED]"
    )
    expect(Position.filter_attributes.map(&:to_s)).to include("postal_code", "latitude", "longitude")
  end
end
