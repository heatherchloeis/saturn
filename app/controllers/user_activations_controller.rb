class UserActivationsController < ApplicationController
  def edit
  	user = User.find_by(email: params[:email])
  	if user && !user.activated? && user.authenticated?(:activation, params[:id])
  		user.activate
  		log_in user
  		flash[:success] = "YEET (ﾉ●ω●)ﾉ*:･ﾟ✧ Your Account Has Been Activated!"
  		redirect_to login_url
  	else
  		flash[:danger] = "REEE (づಠ╭╮ಠ)づ Invalid Activation Link!"
  		redirect_to root_url
  	end
  end
end