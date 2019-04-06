class UsersController < ApplicationController
	before_action :set_user,			only: [:edit,
																			 :update,
																			 :destroy]
																			 
	def index
		@users = User.all
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			# Handle a successful user update
			flash[:success] = "Your Settings Have Been Successfully Updated (ﾉ●ω●)ﾉ*:･ﾟ✧"
			redirect_to root_url
		else
			# Handle an unsuccessful user update
			flash[:danger] = "Oh Dear (づಠ╭╮ಠ)づ Something Seems to Have Gone Wrong! Please Try Again"
			render 'edit'
		end		
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "The User Has Been Successfully Deleted o(╥﹏╥)o"
		redirect_to users_url
	end

	private
		def user_params
			params.require(:user).params(:email,
																	 :password,
																	 :password_confirmation)
		end

		def set_user
			@user = User.find_by(id: params[:id])
		end
end