class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail(to: "#{@user.name} <#{@user.email}>", subject: "Password Reset Link")
  end

  def registration_confirmation(user)
    @user = user

    mail(to: "#{@user.name} <#{@user.email}>", subject: "Registration Confirmation")
  end
end
