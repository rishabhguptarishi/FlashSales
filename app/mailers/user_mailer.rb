class UserMailer < ApplicationMailer
  default from: ENV['default_mailers_from']
  #FIXME_AB: You can use before action

  #FIXME_AB: set default_from here from env

  def password_reset(user_id)
    #FIXME_AB: find user with id and if user not found don't send email
    @user = User.find(user_id)
    if @user
      mail(to: "#{@user.name} <#{@user.email}>", subject: "Password Reset Link")
    end
  end

  def registration_confirmation(user_id)
    @user = User.find(user_id)
    #FIXME_AB: you should check that account is not verified already before sending this email
    if @user && !@user.verified
      mail(to: "#{@user.name} <#{@user.email}>", subject: "Registration Confirmation")
    end
  end
end
