class UserMailer < ApplicationMailer

  #FIXME_AB: You can use before action

  #FIXME_AB: set default_from here from env

  def password_reset(user)
    #FIXME_AB: find user with id and if user not found don't send email
    @user = user
    mail(to: "#{@user.name} <#{@user.email}>", subject: "Password Reset Link")
  end

  def registration_confirmation(user)
    @user = user
    #FIXME_AB: you should check that account is not verified already before sending this email
    mail(to: "#{@user.name} <#{@user.email}>", subject: "Registration Confirmation")
  end
end
