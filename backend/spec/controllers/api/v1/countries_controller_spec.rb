require 'rails_helper'

RSpec.describe Api::V1::CountriesController do
  let(:test_country_id) { 'IT' }
  let(:test_country_name_en) { 'Italy' }
  let(:test_country_name_it) { 'Italia' }

  describe 'index' do
    let(:all_countries_count) { Country.all.count }
    it 'returns all countries' do
      get :index
      expect(response_body[:countries].size).to eq all_countries_count
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translations" do
        get :index
        test_country = response_body[:countries].find { |c| c[:id].eql?(test_country_id) }
        expect(test_country[:name]).to eq test_country_name_en
      end
    end
    context "with 'it' locale" do
      before { I18n.default_locale = 'it' }
      it "returns 'it' translations" do
        get :index
        test_country = response_body[:countries].find { |c| c[:id].eql?(test_country_id) }
        expect(test_country[:name]).to eq test_country_name_it
      end
    end
  end

  describe 'show' do
    it 'returns test country' do
      get :show, id: test_country_id
      expect(response_body[:country][:id]).to eq test_country_id
    end
    it 'returns test country case-insensitive' do
      get :show, id: test_country_id.downcase
      expect(response_body[:country][:id]).to eq test_country_id
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translation" do
        get :show, id: test_country_id
        expect(response_body[:country][:name]).to eq test_country_name_en
      end
    end
    context "with 'it' locale" do
      before { I18n.default_locale = 'it' }
      it "returns 'it' translation" do
        get :show, id: test_country_id
        expect(response_body[:country][:name]).to eq test_country_name_it
      end
    end
    context 'with unexisting country id' do
      let(:unexisting_country_id) { 'XY' }
      it 'returns 404 (Not Found)' do
        get :show, id: unexisting_country_id
        expect(response.status).to eq 404
      end
    end
    context 'with invalid country id' do
      let(:unexisting_country_id) { 'X1' }
      it 'returns 400 (Bad Request)' do
        get :show, id: unexisting_country_id
        expect(response.status).to eq 400
      end
    end
  end
end
