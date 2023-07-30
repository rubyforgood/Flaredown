require "rails_helper"

RSpec.describe ChartsPattern do
  it "instantiates a ChartPattern instance" do
    user = create(:user)
    pattern = create(:pattern, encrypted_user_id: user.encrypted_id)

    chart_pattern = ChartsPattern.new({start_at: pattern.start_at, end_at: pattern.end_at, pattern: pattern})

    expect(chart_pattern.pattern.id).to eq pattern.id
  end

  it "generates chart data from a ChartPattern" do
    user = create(:user)
    pattern = create(:pattern, encrypted_user_id: user.encrypted_id)

    chart_pattern = ChartsPattern.new({start_at: pattern.start_at, end_at: pattern.end_at, pattern: pattern})
    chart_data = chart_pattern.chart_data

    expect(chart_data[:pattern_name]).to eq pattern.name
    expect(chart_data[:author_email]).to eq user.email
  end

  it "generates chart data from a ChartPattern with a valid category" do
    user = create(:user)
    pattern = create(:pattern, encrypted_user_id: user.encrypted_id, includes: [{category: "treatments"}])

    chart_pattern = ChartsPattern.new({start_at: pattern.start_at, end_at: pattern.end_at, pattern: pattern})
    chart_data = chart_pattern.chart_data

    expect(chart_data[:pattern_name]).to eq pattern.name
    expect(chart_data[:author_email]).to eq user.email
  end

  it "generates chart data from a ChartPattern with untracked category" do
    user = create(:user)
    pattern = create(:pattern, encrypted_user_id: user.encrypted_id, includes: [{category: "not-a-category"}])

    chart_pattern = ChartsPattern.new({start_at: pattern.start_at, end_at: pattern.end_at, pattern: pattern})
    chart_data = chart_pattern.chart_data

    expect(chart_data[:pattern_name]).to eq pattern.name
    expect(chart_data[:author_email]).to eq user.email
  end
end
