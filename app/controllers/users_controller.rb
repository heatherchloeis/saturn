class UsersController < ApplicationController
	before_action :logged_in_user,	only: [:edit,
																				 :update,
																				 :destroy]

  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,			only: :destroy

	before_action :set_user,				only: [:edit,
																				 :update,
																				 :destroy]
																			 
	def index
		@users = User.where(activated: true)
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			# Handle a successful user creation
			@user.send_activation_email
			flash[:success] = "Welcome to Kalendarize (ﾉ●ω●)ﾉ*:･ﾟ✧ Please Check Your Email to Activate Your Account!!!"
			redirect_to login_url
		else
			flash[:danger] = "Oh Dear (づಠ╭╮ಠ)づ Something Seems to Have Gone Wrong with Your Submission! Please Try Again"
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			# Handle a successful user update
			flash[:success] = "Your Settings Have Been Successfully Updated (ﾉ●ω●)ﾉ*:･ﾟ✧"
			redirect_to edit_user_url(@user)
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
			params.require(:user).permit(:email,
																	 :username,
																	 :password,
																	 :password_confirmation)
		end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
    	redirect_to(root_url) unless current_user.admin?
    end

		def set_user
			@user = User.find_by(id: params[:id])
		end
end