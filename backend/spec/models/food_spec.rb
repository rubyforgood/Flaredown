require "rails_helper"

RSpec.describe Food do
  describe "Respond to" do
    it { is_expected.to respond_to(:long_desc) }
    it { is_expected.to respond_to(:shrt_desc) }
    it { is_expected.to respond_to(:comname) }
    it { is_expected.to respond_to(:sciname) }
  end

  describe "class methods" do
    # Descriptors are fixed rather than FFaker::Lorem.word, and chosen so the three
    # global rows rank distinctly. Two independent hazards otherwise:
    #
    #   1. FFaker::Lorem::WORDS contains "a", "at" and "in", which the english text
    #      search config strips as stopwords. "TestFood at" then has the tsvector
    #      'testfood':1 and ranks 0.14426951 -- the same as a bare "TestFood" --
    #      instead of 0.09102392, which reorders the result. Roughly a 3% chance per
    #      run across the two draws.
    #   2. Equal ranks left the ordering to Postgres, which is free to return tied
    #      rows in any order.
    #
    # "TestFood alpha" ranks 0.09102392 and "TestFood alpha bravo" 0.072134756, so
    # these expectations rest on relevance alone and not on tie-break behaviour.
    let!(:global_food) { create(:food, long_desc: "TestFood") }
    let!(:same_food_1) { create(:food, long_desc: "TestFood alpha") }
    let!(:same_food_2) { create(:food, long_desc: "TestFood alpha bravo") }

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

      it "returns equally ranked foods in a stable order" do
        # Identical descriptions rank identically, so ts_rank_cd cannot separate these.
        # The `f.id ASC` tie-breaker in fts_sql decides the order; without it Postgres
        # is free to return tied rows however the heap happens to be laid out, which is
        # what made this file order-dependent in full-suite runs.
        tied_a = create(:food, long_desc: "TiedFood")
        tied_b = create(:food, long_desc: "TiedFood")

        expect(Food.send(:fts, "TiedFood", 2, user_food.user_id)).to eq [tied_a, tied_b]
      end
    end
  end
end
