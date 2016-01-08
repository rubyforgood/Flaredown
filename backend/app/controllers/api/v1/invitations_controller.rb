class Api::V1::InvitationsController < ApplicationController

  def show
    invitation = User.find_by_invitation_token(params[:id], true).invitation
    invitation.id = params[:id]
    render json: invitation
  end

end
