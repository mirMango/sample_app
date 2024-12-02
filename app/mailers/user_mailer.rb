class UserMailer < ApplicationMailer
  # Sends account activation email
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Sends password reset email
  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
