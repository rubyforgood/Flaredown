require 'swagger_helper'

RSpec.describe 'api/v1/treatments', type: :request do
  path '/api/treatments' do
    before do
      create_list(:treatment, 3)
    end

    get('list treatments') do
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
         pending "Not yet implemented, when implemented uncomment the assertion below"
        # run_test!
      end
    end

    post('create treatment') do
      parameter name: :treatment, in: :body
      response(200, 'successful') do
        let(:treatment) { {treatment: { name: 'Aspirin' }} }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
         pending "Not yet implemented, when implemented uncomment the assertion below"
        # run_test!
      end
    end
  end

  path '/api/treatments/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show treatment') do
      response(200, 'successful') do
        let(:id) { Treatment.pick(:id) }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
         pending "Not yet implemented, when implemented uncomment the assertion below"
        # run_test!
      end
    end
  end
end
