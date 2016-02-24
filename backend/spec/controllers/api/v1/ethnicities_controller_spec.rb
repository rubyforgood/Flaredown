require 'rails_helper'

RSpec.describe Api::V1::EthnicitiesController do
  let(:test_ethnicity_id) { 'south_asian' }
  let(:test_ethnicity_name_en) { 'South Asian' }

  describe 'index' do
    let(:all_ethnicities_count) { Ethnicity.all.count }
    it 'returns all ethnicities' do
      get :index
      expect(response_body[:ethnicities].size).to eq all_ethnicities_count
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translations" do
        get :index
        test_ethnicity = response_body[:ethnicities].find { |c| c[:id].eql?(test_ethnicity_id) }
        expect(test_ethnicity[:name]).to eq test_ethnicity_name_en
      end
    end
  end

  describe 'show' do
    it 'returns test ethnicity' do
      get :show, id: test_ethnicity_id
      expect(response_body[:ethnicity][:id]).to eq test_ethnicity_id
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translation" do
        get :show, id: test_ethnicity_id
        expect(response_body[:ethnicity][:name]).to eq test_ethnicity_name_en
      end
    end
    context 'with invalid ethnicity id' do
      let(:invalid_ethnicity_id) { 'blah' }
      it 'returns 400 (Bad Request)' do
        get :show, id: invalid_ethnicity_id
        expect(response.status).to eq 400
      end
    end
  end
end
