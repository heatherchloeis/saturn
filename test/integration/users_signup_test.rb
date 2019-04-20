require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
	end

	test "invalid user submission" do 
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, params: { user: { username: "$example.user", 
																				 email: "user@example", 
																				 password: "user",
																				 password_confirmation: "example" } }
		end
		assert_template 'users/new'
	end

	test "valid user submission with user activation" do 
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, params: { user: { username: "exampleuser", 
																				 email: "user@example.com", 
																				 password: "password",
																				 password_confirmation: "password" } }
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		# Try to log in before activation
		log_in_as(user)
		assert_not is_logged_in?
		# Try invalid activation token
		get edit_user_activation_path("invalid token", email: user.email)
		assert_not is_logged_in?
		# Try valid activation token, but wrong email
		get edit_user_activation_path(user.activation_token, email: 'wrong')
		assert_not is_logged_in?
		# Try valid activation token
		get edit_user_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!
		assert is_logged_in?
	end
end