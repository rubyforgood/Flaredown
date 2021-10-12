require "rails_helper"

RSpec.describe Api::V1::PasswordsController do
  let(:user) { create(:user, password: "ValidPassword123", password_confirmation: "ValidPassword123") }

  describe "create" do
    context "when attempting to reset a password" do
      let(:password_params) do
        {
          # Match the form posted by the front end
          current_password: nil,
          email: nil,
          password: nil,
          password_confirmation: nil,
          reset_password_token: nil,
        }
      end

      context "for an that email exists in the database" do
        it "returns a password reset object" do
          expect_any_instance_of(User).to receive(:send_reset_password_instructions).and_return true
          post :create, params: { password: password_params.merge(email: user.email) }
          expect(response.status).to eq 200
          expect(response_body[:password]).to include({"email" => user.email})
        end

        it "finds a user by case-insensitive email address" do
          other_user = create :user, email: "areallycamelcaseemail@gmail.com"
          expect_any_instance_of(User).to receive(:send_reset_password_instructions).and_return true
          post :create, params: { password: password_params.merge(email: "AReallyCamelCaseEmail@GmAiL.CoM") }
          expect(response.status).to eq 200
          expect(response_body[:password]).to include({"email" => other_user.email})
        end
      end

      context "for an email that does not exist in the database" do
        it "returns a 404" do
          expect_any_instance_of(User).to_not receive(:send_reset_password_instructions)
          post :create, params: { password: password_params.merge(email: "Idonotexist@example.com") }
          expect(response.status).to eq 404
        end
      end
    end
  end

  describe "update" do
    context "when no user logged-in" do
      context "when missing token" do
        it "returns 422  (Unprocessable Entity)" do
          put :update, params: {id: 1}
          expect(response.status).to eq 422
        end
      end
      context "when provide token" do
        it "returns password " do
          put :update, params: {id: 1, token: "123"}
          expect(response.status).to eq 422
        end
      end
    end

    context "when user logged-in" do
      before { sign_in user }

      context "when provide right params" do
        it "update password" do
          put(:update, params: {id: user.id, password: {
            current_password: "ValidPassword123",
            password: "password123",
            password_confirmation: "password123"
          }})
          expect(response_body[:password][:email]).to eq user.email
        end
      end

      context "when password confirmation is wrong" do
        it "returns 422  (Unprocessable Entity)" do
          put :update, params: {id: user.id, password: {password: "password123", password_confirmation: "password"}}
          expect(response.status).to eq 422
        end
      end

      context "when current password is wrong" do
        it "returns 422  (Unprocessable Entity)" do
          put(:update, params: {id: user.id, password: {
            current_password: "InvalidPassword123",
            password: "password123",
            password_confirmation: "password123"
          }})

          expect(response.status).to eq 422
        end
      end
    end
  end
end
