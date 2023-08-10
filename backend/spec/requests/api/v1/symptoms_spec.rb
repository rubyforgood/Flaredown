require "swagger_helper"

RSpec.describe "api/v1/symptoms", type: :request do
  path "/api/symptoms/{id}" do
    get("show symptom") do
      parameter name: "id", in: :path, type: :integer, description: "id"
      produces "application/json"

      response(200, "successful") do
        let(:id) { create(:symptom).id }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
