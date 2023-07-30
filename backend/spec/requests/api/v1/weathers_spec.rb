require "swagger_helper"

RSpec.describe "api/v1/weathers", type: :request do
  path "/api/weathers" do
    pending("The weather API curretly doesn't work as expected, so not testing at this time")
    get("list weathers") do
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
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
