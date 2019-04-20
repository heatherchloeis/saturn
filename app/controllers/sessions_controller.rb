class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
    	if user.activated?
    		log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    		redirect_back_or root_url
      else
        message = "REEE (づಠ╭╮ಠ)づ Your Account Has Not Yet Been Activated!"
        message += "Check Your Email!"
        flash[:warning] = message
        redirect_to root_url
      end        
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