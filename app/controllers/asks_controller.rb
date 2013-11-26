class AsksController < ApplicationController
 def destroy
  	@ask = Ask.find(params[:id])
	@ask.destroy
	redirect_to root_url
  end
end
