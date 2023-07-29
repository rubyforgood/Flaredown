require 'swagger_helper'

RSpec.describe 'api/v1/searches', type: :request do
  path '/api/searches' do

    get('show search') do
      response(200, 'successful') do

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
