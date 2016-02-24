require 'rails_helper'

RSpec.describe Api::V1::EducationLevelsController do
  let(:test_education_level_id) { 'bachelors_degree' }
  let(:test_education_level_name_en) { "Bachelor's degree" }

  describe 'index' do
    let(:all_education_levels_count) { EducationLevel.all.count }
    it 'returns all education_levels' do
      get :index
      expect(response_body[:education_levels].size).to eq all_education_levels_count
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translations" do
        get :index
        test_education_level = response_body[:education_levels].find { |c| c[:id].eql?(test_education_level_id) }
        expect(test_education_level[:name]).to eq test_education_level_name_en
      end
    end
  end

  describe 'show' do
    it 'returns test education_level' do
      get :show, id: test_education_level_id
      expect(response_body[:education_level][:id]).to eq test_education_level_id
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translation" do
        get :show, id: test_education_level_id
        expect(response_body[:education_level][:name]).to eq test_education_level_name_en
      end
    end
    context 'with invalid education_level id' do
      let(:invalid_education_level_id) { 'blah' }
      it 'returns 400 (Bad Request)' do
        get :show, id: invalid_education_level_id
        expect(response.status).to eq 400
      end
    end
  end
end
