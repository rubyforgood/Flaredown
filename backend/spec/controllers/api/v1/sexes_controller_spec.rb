require 'rails_helper'

RSpec.describe Api::V1::SexesController do

  let(:test_sex_id) { 'male' }
  let(:test_sex_name_en) { 'Male' }
  let(:test_sex_name_it) { 'Maschio' }

  describe 'index' do
    let(:all_sexes_count) { Sex.all.count }
    it 'returns all sexes' do
      get :index
      expect(response_body[:sexes].size).to eq all_sexes_count
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translations" do
        get :index
        test_sex = response_body[:sexes].find {|c| c[:id].eql?(test_sex_id)}
        expect(test_sex[:name]).to eq test_sex_name_en
      end
    end
    context "with 'it' locale" do
      before { I18n.default_locale = 'it' }
      it "returns 'it' translations" do
        get :index
        test_sex = response_body[:sexes].find {|c| c[:id].eql?(test_sex_id)}
        expect(test_sex[:name]).to eq test_sex_name_it
      end
    end
  end

  describe 'show' do
    it 'returns test sex' do
      get :show, id: test_sex_id
      expect(response_body[:sex][:id]).to eq test_sex_id
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translation" do
        get :show, id: test_sex_id
        expect(response_body[:sex][:name]).to eq test_sex_name_en
      end
    end
    context "with 'it' locale" do
      before { I18n.default_locale = 'it' }
      it "returns 'it' translation" do
        get :show, id: test_sex_id
        expect(response_body[:sex][:name]).to eq test_sex_name_it
      end
    end
    context 'with invalid sex id' do
      let(:invalid_sex_id) { 'blah' }
      it 'returns 400 (Bad Request)' do
        get :show, id: invalid_sex_id
        expect(response.status).to eq 400
      end
    end
  end

end
