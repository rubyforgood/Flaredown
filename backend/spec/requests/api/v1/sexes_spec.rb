require "swagger_helper"

RSpec.describe "api/v1/sexes", type: :request do
  path "/api/sexes" do
    get("list sexes") do
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

  path "/api/sexes/{id}" do
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show sex") do
      response(200, "successful") do
        let(:id) { "female" }

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
