require 'swagger_helper'

RSpec.describe 'api/v1/weathers', type: :request do
  before { sign_in create(:user) }

  path '/api/weathers' do

    get('list weathers') do
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
