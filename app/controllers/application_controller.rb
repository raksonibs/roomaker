class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if params[:email]
      current_user ||= User.find(session[:user_id]) if session[:user_id]
    else
  	 current_user ||= User.find_by_id(session[:user_id])
    end
  end


  def smallimage 
    "http://graph.facebook.com/#{current_user.uid}/picture?type=small" 
  end

  helper_method :current_user, :smallimage

end
=begin
def current_user
  	@current_users ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
=end