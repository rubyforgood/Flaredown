module Api
  module V1
    class InvitationsController < ApplicationController
      skip_before_action :authenticate_user!

      def show
        render json: Invitation.find(params[:id])
      end

      def update
        invitation = Invitation.find(params[:id])
        invitation.accept!(
          params.require(:invitation).permit(:email, :password, :password_confirmation)
        )
        render json: invitation
      end
    end
  end
end
