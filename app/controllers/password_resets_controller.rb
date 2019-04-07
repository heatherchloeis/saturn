class PasswordResetsController < ApplicationController
	before_action :get_user,					only: [:edit, :update]
	before_action :valid_user,				only: [:edit, :update]
	before_action :check_expiration,	only: [:edit, :update]

  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "Okay (~ಠ◡ಠ)~ Help Is On The Way!"
  		redirect_to root_url
  	else
  		flash.now[:danger] = "Oh no o(╥﹏╥)o We Couldn't Find Any Account Associated with That Email! Please Try Again"
  		render 'new'
  	end
  end

  def edit
  end

  def update
  	if params[:user][:password].empty?
  		@user.errors.add(:password, "Passwords Aren't Like Taylor Swift...No Blank Spaces!")
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
      @user.update_attribute(:reset_digest, nil)
  		flash[:success] = "Success (ﾉ●ω●)ﾉ*:･ﾟ✧ Try Not to Forget This One"
  		redirect_to root_url
  	else
  		render 'edit'
  	end
  end

  private
  	def user_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end

  	def get_user
  		@user = User.find_by(email: params[:email])
  	end

  	# Confirms if a valid user
  	def valid_user
  		unless (@user && @user.authenticated?(:reset, params[:id]))
  			redirect_to root_url
  		end
  	end

  	# Checks expiration date of reset token
  	def check_expiration
  		if @user.password_reset_expired?
  			flash[:danger] = "Oh no (づಠ╭╮ಠ)づ Seems That Reset Request Has Expired"
  			redirect_to new_password_reset_url
  		end
  	end
end