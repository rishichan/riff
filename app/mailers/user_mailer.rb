# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: "rishabh.jain@gocomet.com"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url = "http://example.com/login"
    mail(to: @user.email, subject: "Welcome to Our App!")
  end

  def verification_email(user_id)
    @user = Artist.find(user_id)
    mail(to: @user.email, subject: "Verify your email")
  end
end
