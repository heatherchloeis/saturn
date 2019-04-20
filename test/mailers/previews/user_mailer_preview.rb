# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/user_activation
  def user_activation
  	user = User.first
  	user.activation_token = User.new_token
    UserMailer.user_activation(user)
  end
  
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
