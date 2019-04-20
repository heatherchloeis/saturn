require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:one)
	end

	test "invalid edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), params: { user: { username: "one_user",
																							email: "",
																							password: "pass",
																							password_confirmation: "word" } }
		assert_template 'users/edit'
	end

	test "valid edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		username = "first_user"
		patch user_path(@user), params: { user: { username: username,
																							password: "",
																							password_confirmation: "" } }
		assert_not flash.empty?
		assert_redirected_to edit_user_path(@user)
		@user.reload
		assert_equal username, @user.username
	end

	test "should redirect edit when not logged in" do
		get edit_user_path(@user)
		assert_not flash.empty?
		assert_redirected_to login_url
	end

	test "should redirect update when not logged in" do
		patch user_path(@user), params: { user: { username: @user.username } }
		assert_not flash.empty?
		assert_redirected_to login_url
	end

	test "valid edit with friendly forwarding" do
		get edit_user_path(@user)
		log_in_as(@user)
		assert_redirected_to edit_user_path(@user)
		email = "foo@bar.com"
		patch user_path(@user), params: { user: { email: email,
																							password: "",
																							password_confirmation: "" } }
		assert_not flash.empty?
		assert_redirected_to edit_user_path(@user)
		@user.reload
		assert_equal email, @user.email
	end
end
