require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:one)
	end

	test "password resets" do 
		get new_password_reset_path
		assert_template 'password_resets/new'
		# Try invalid email
		post password_resets_path, params: { password_reset: { email: "" } }
		assert_not flash.empty?
		assert_template 'password_resets/new'
		# Try valid email
		post password_resets_path, params: { password_reset: { email: @user.email } }
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url
		# Try password reset form
		user = assigns(:user)
		# Try wrong email
		get edit_password_reset_path(user.reset_token, email: "")
		assert_redirected_to root_url
		# Try correct email but wrong token
		get edit_password_reset_path('wrong token', email: user.email)
		assert_redirected_to root_url
		# Try correct email and correct token
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_template 'password_resets/edit'
		assert_select "input[name=email][type=hidden][value=?]", user.email
		# Try invalid password and password confirmation
		patch password_reset_path(user.reset_token), params: { email: user.email,
																													 user: { password: 							"fooobarr",
																													 				 password_confirmation: "barrfooo" } }
		# Try empty password
		patch password_reset_path(user.reset_token), params: { email: user.email,
																													 user: { password: 							"",
																													 				 password_confirmation: "" } }
		# Try valid password and password confirmation
		patch password_reset_path(user.reset_token), params: { email: user.email,
																													 user: { password: 							"fooobarr",
																													 				 password_confirmation: "fooobarr" } }
		assert is_logged_in?
		assert_not flash.empty?
		assert_redirected_to root_url
	end

	test "expired reset token" do
		get new_password_reset_path
		post password_resets_path, params: { password_reset: { email: @user.email } }
		@user = assigns(:user)
		@user.update_attribute(:reset_sent_at, 4.hours.ago)
		patch password_reset_path(@user.reset_token), params: { email: @user.email,
																													 	user: { password: 						"fooobarr",
																													 				  password_confirmation: "fooobarr" } }
		assert_response :redirect 
		follow_redirect!
		# assert_match /expired/i, response.body
	end
end