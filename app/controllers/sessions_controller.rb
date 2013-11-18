class SessionsController < ApplicationController
  skip_before_filter :set_current_user
  def new
  end

  def create
    if params[:email]
      user=User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] =user.id
        render "welcome/index"
        flash[:notice] = "Logged in!"
        session[:yes]=[]
        session[:no]=[]
      else
        flash.now[:alert] = "Invalid"
        render "new"
      end

    else

  	  user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url

    end
  end

  def failure
    flash[:error]= "Nope"
  	redirect_to root_url
  end

  def destroy
  	session.delete(:user_id)
  	flash[:notice] = "Logged out!"
  	redirect_to root_url
  end
end

=begin
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
=end