require 'rails_helper'

RSpec.describe Api::V1::StepsController do

  let(:step_id) { 'onboarding-conditions' }
  let(:step_title_en) { 'What conditions will you track?' }

  describe 'index' do
    let(:all_steps_count) { Step.all.count }
    it 'returns all steps' do
      get :index
      expect(response_body[:steps].size).to eq all_steps_count
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translations" do
        get :index
        step = response_body[:steps].find {|s| s[:id].eql?(step_id)}
        expect(step[:title]).to eq step_title_en
      end
    end
  end

  describe 'show' do
    it 'returns test step' do
      get :show, id: step_id
      expect(response_body[:step][:id]).to eq step_id
    end
    context "with 'en' locale" do
      before { I18n.default_locale = 'en' }
      it "returns 'en' translation" do
        get :show, id: step_id
        expect(response_body[:step][:title]).to eq step_title_en
      end
    end
    context 'with unexisting step id' do
      let(:unexisting_step_id) { '666' }
      it 'returns 404 (Not Found)' do
        get :show, id: unexisting_step_id
        expect(response.status).to eq 404
      end
    end
  end

end
