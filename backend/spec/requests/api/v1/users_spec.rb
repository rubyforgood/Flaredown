require "swagger_helper"

RSpec.describe "api/v1/users", type: :request do
  before { sign_in create(:user) }

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
        run_test!
      end
    end

    patch("update user") do
      response(200, "successful", use_as_request_example: true) do
        let(:params) { {user: {email: "updatedemail@example.com"}} }

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
