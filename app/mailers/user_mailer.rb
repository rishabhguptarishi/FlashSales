class UserMailer < ApplicationMailer
  default from: ENV['default_mailers_from']

  def password_reset(user_id)
    @user = User.find(user_id)
    if @user
      mail(to: "#{@user.name} <#{@user.email}>", subject: "Password Reset Link")
    end
  end

  def registration_confirmation(user_id)
    @user = User.find(user_id)
    if @user && !@user.verified
      mail(to: "#{@user.name} <#{@user.email}>", subject: "Registration Confirmation")
    end
  end
end
