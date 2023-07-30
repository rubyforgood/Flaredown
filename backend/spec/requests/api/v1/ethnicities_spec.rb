require "swagger_helper"

RSpec.describe "api/v1/ethnicities", type: :request do
  path "/api/ethnicities" do
    get("list ethnicities") do
      response(200, "successful") do
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

  path "/api/ethnicities/{id}" do
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show ethnicity") do
      response(200, "successful") do
        let(:id) { "latino" }

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
