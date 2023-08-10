require "swagger_helper"

RSpec.describe "api/v1/users", type: :request do
  path "/api/users/{id}" do
    parameter name: "id", in: :path, type: :string, description: "id"

    let(:id) { User.pick(:id) }

    get("show user") do
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

    patch("update user") do
      parameter name: :user, in: :body

      response(200, "successful") do
        let(:user) { {user: {email: "updatedemail@example.com"}} }
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
