class UserMailer < ApplicationMailer
  def password_reset(user)
  	@user = user
  	mail to: user.email, subject: "Seems You've Forgotten Your Password (Again)"
  end
end
