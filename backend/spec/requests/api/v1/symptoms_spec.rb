require "rails_helper"
require 'swagger_helper'

RSpec.describe 'api/v1/symptoms', type: :request do
  let!(:user) { create(:user) }

  before { sign_in user }

  path '/api/symptoms/{id}' do

    get('show symptom') do
      parameter name: 'id', in: :path, type: :integer, description: 'id'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 symptom: {
                   type: :object,
                   properties: {
                     id: { type: :integer, required: true },
                     updated_at: { type: :string, required: true },
                     created_at: { type: :string, required: true },
                     type: { type: :string, required: true },
                     color_id: { type: :integer, nullable: true },
                     users_count: { type: :integer, required: true },
                     name: { type: :string, required: true },
                   },
                 }
               },
                required: [:symptom]

        let(:id) { create(:symptom).id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
