class UserMailer < ApplicationMailer
  def user_activation(user)
    @user = user
    mail to: user.email, subject: "Activate Your Account!"
  end

  def password_reset(user)
  	@user = user
  	mail to: user.email, subject: "Seems You've Forgotten Your Password (Again)"
  end
end
