class InvitesController < ApplicationController
  def destroy
  	@invite = Invite.find(params[:id])
	@invite.destroy
	redirect_to root_url
  end
end
