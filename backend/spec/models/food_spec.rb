require "rails_helper"

RSpec.describe Food do
  describe "Respond to" do
    it { is_expected.to respond_to(:long_desc) }
    it { is_expected.to respond_to(:shrt_desc) }
    it { is_expected.to respond_to(:comname) }
    it { is_expected.to respond_to(:sciname) }
  end

  describe "class methods" do
    let!(:global_food) { create(:food, long_desc: "TestFood") }
    let!(:same_food_1) { create(:food, long_desc: "TestFood #{FFaker::Lorem.word}") }
    let!(:same_food_2) { create(:food, long_desc: "TestFood #{FFaker::Lorem.word}") }

    let!(:personal_food) { create(:food, :personal, long_desc: "TestFood") }
    let!(:user_food) { create(:user_food, food: personal_food) }

    let(:query) { {name: "TestFood"} }

    MAX_ROWS = 2

    describe "fts" do
      it "return same global foods" do
        another_user = create(:user)
        result = Food.send(:fts, query[:name], MAX_ROWS, another_user.id)

        expect(result).to eq [global_food, same_food_1]
        expect(result.count).to eq MAX_ROWS
        expect(result.count).to_not eq Food.where(global: true).count
        expect(result.include?(personal_food)).to be false
      end

      it "retrun local and global foods for author" do
        expect(Food.send(:fts, query[:name], MAX_ROWS, user_food.user_id)).to eq [global_food, personal_food]
      end
    end
  end
end
