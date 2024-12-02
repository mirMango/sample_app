class UserMailer < ApplicationMailer
  # Sends account activation email
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Sends password reset email
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
