class WelcomeController < ApplicationController
  def index
  	if current_user
  		@invites=current_user.invites
  		
  	end
  end
end
