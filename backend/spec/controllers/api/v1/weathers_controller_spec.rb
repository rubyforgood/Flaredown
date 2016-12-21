require 'rails_helper'

describe Api::V1::WeathersController do
  let(:user) { create(:user) }
  let(:date) { '2016-01-06' }
  let(:postal_code) { '55403' }
  let(:index_action) { get :index, date: date, postal_code: postal_code, format: :js }

  context 'anonymous user' do
    describe 'index' do
      it 'should not hit weather API' do
        expect(WeatherRetriver).not_to receive(:get)

        index_action
      end

      it 'should not authorize' do
        index_action

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'user is present' do
    before { sign_in user }

    describe 'index' do
      let(:weather) { create :weather }
      let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
      let(:expected_keys) { %i(id humidity icon precip_intensity pressure temperature_max temperature_min) }
      let(:not_expected_keys) { %i(date postal_code) }

      before { expect(WeatherRetriver).to receive(:get).with(Date.parse(date), postal_code).and_return(weather) }
      before { index_action }

      subject { json_response[:weather].keys }

      it { is_expected.to include(*expected_keys) }
      it { is_expected.not_to include(*not_expected_keys) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
