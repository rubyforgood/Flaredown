require 'rails_helper'

RSpec.describe Api::V1::SearchesController do

  let!(:user) { create(:user) }
  let!(:conditions) { create_list(:condition, 5) }

  before { sign_in user }

  describe 'show' do
    context 'when searchable exists for the requested date' do

      before { I18n.default_locale = :en }

      let!(:condition_to_find) { create(:condition, name: 'ACL injury') }

      it 'returns correct searchables with first three letters' do
        get :show, resource: 'condition', query: { name: 'ACL' }
        expect_valid_responses(response_body)
      end

      it 'returns correct searchables with bad type' do
        get :show, resource: 'condition', query: { name: 'ACL inuj' }
        expect_valid_responses(response_body)
      end

      def expect_valid_responses(response)
        expect(response[:search][:searchables].count).to eq 1
        expect(response[:search][:searchables][0][:type]).to eq 'condition'
        expect(response[:search][:searchables][0][:name]).to eq 'ACL injury'
      end
    end
  end

end
