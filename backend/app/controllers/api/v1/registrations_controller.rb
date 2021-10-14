module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :authenticate_user!

      def create
        render json: Registration.create!(params)
      end

      def destroy
        render json: Registration.delete!(params)
      end
    end
  end
end
