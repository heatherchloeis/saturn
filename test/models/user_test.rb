require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = 			User.new(email: "user@example.com",
													 password: "password",
													 password_confirmation: "password")
		@other_user = User.new(email: "other_user@example.com",
										 			 password: "password",
										 			 password_confirmation: "password")
	end

	test "should be valid" do 
		assert @user.valid?
	end

	test "email and password should be present" do 
		@user.email = "   "
		@user.password = "   "
		assert_not @user.valid?
	end

	test "password should have min characters" do
		@user.password = "a" * 7
		assert_not @user.valid?		
	end

	test "email should have max characters" do
		@user.email = "a" * 241 + "example.com"
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

	test "email should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
		mixed_case_email = "UsEr@ExAmPlE.com"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	# User login/logout testing suite

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end
end