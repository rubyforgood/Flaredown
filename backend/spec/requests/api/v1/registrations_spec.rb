require 'swagger_helper'

RSpec.describe 'api/v1/registrations', type: :request do
  path '/api/registrations/destroy' do

    put('delete registration') do
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
         pending "Not yet implemented, when implemented uncomment the assertion below"
        #  pending "Not yet implemented, when implemented uncomment the assertion below"
        # run_test!
      end
    end
  end

  path '/api/registrations' do

    post('create registration') do
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
  end
end
