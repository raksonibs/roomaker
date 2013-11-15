class SessionsController < ApplicationController
  def new
  end

  def create
  	session[:return_to] ||= request.referer
  	user=User.find_by_email(params[:email])
  	if user && user.authenticate(params[:password])
  		session[:user_id] =user.id
  		render "welcome/index"
  		flash[:notice] = "Logged in!"
  	else
  		flash.now[:alert] = "Invalid"
  		render "new"
  	end
  end

  def destroy
  	session[:user_id]=nil
  	render "welcome/index", :notice => "Logged out!"
  end
end
