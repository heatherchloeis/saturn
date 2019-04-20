require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = 			User.new(email: "user@example.com",
													 username: "user_user",
													 password: "password",
													 password_confirmation: "password")
		@other_user = User.new(email: "other_user@example.com",
										 			 password: "password",
										 			 password_confirmation: "password")
	end

	test "should be valid" do 
		assert @user.valid?
	end

	test "email, username and password should be present" do 
		@user.email = "   "
		@user.username = "   "
		@user.password = "   "
		assert_not @user.valid?
	end

	test "username and password should have min characters" do
		@user.username = "a" * 3
		@user.password = "a" * 7
		assert_not @user.valid?		
	end

	test "email and username should have max characters" do
		@user.email = "a" * 241 + "example.com"
		@user.username = "a" * 51
		assert_not @user.valid?
	end

	test "email should contain valid characters" do
		valid_emails = %w[user@example.com example_USER@example.com example+user1@example.co ex.ample-user@example.user.com]
		valid_emails.each do |valid_email|
			@user.email = valid_email
			assert @user.valid?
		end
	end

	test "email should not contain invalid characters" do
		invalid_emails = %w[user@example,com $user()example.co user_at_example user@ex+ample.com user@ex_ample.com user@example.]
		invalid_emails.each do |invalid_email|
			@user.email = invalid_email
			assert_not @user.valid?
		end
	end

	test "email and username should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		duplicate_user.username = @user.username.upcase
		@user.save
		assert_not duplicate_user.valid?
		mixed_case_email = "UsEr@ExAmPlE.com"
		mixed_case_username = "UsEr_UsEr"
		@user.email = mixed_case_email
		@user.username = mixed_case_username
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
		assert_equal mixed_case_username.downcase, @user.reload.username
	end

	# User login/logout testing suite

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end
end