require "rails_helper"

RSpec.describe Api::V1::DayHabitsController do
  let(:test_day_habit_id) { "lying_down" }
  let(:test_day_habit_name_en) { "Lying down" }
  let(:test_day_habit_descr_en) { "bedridden" }

  describe "index" do
    let(:all_day_habits_count) { DayHabit.all.count }
    it "returns all day_habits" do
      get :index
      expect(response_body[:day_habits].size).to eq all_day_habits_count
    end
    context "with 'en' locale" do
      before { I18n.default_locale = "en" }
      it "returns 'en' translations" do
        get :index
        test_day_habit = response_body[:day_habits].find { |c| c[:id].eql?(test_day_habit_id) }
        expect(test_day_habit[:name]).to eq test_day_habit_name_en
        expect(test_day_habit[:description]).to eq test_day_habit_descr_en
      end
    end
  end

  describe "show" do
    it "returns test day_habit" do
      get :show, params: {id: test_day_habit_id}
      expect(response_body[:day_habit][:id]).to eq test_day_habit_id
    end
    context "with 'en' locale" do
      before { I18n.default_locale = "en" }
      it "returns 'en' translation" do
        get :show, params: {id: test_day_habit_id}
        expect(response_body[:day_habit][:name]).to eq test_day_habit_name_en
        expect(response_body[:day_habit][:description]).to eq test_day_habit_descr_en
      end
    end
    context "with invalid day_habit id" do
      let(:invalid_day_habit_id) { "blah" }
      it "returns 400 (Bad Request)" do
        get :show, params: {id: invalid_day_habit_id}
        expect(response.status).to eq 400
      end
    end
  end
end
