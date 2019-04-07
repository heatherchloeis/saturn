class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		# Log in
  		log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  		redirect_to root_url
  	else
  		# Error
  		flash.now[:danger] = "Oh Dear (づಠ╭╮ಠ)づ Something Seems to Have Gone Wrong! Please Try Again"
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end