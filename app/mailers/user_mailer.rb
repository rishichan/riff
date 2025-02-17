# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: "rishabh.jain@gocomet.com"

  def verification_email(user, verification_link)
    @user = user
    @verification_link = verification_link
    mail(to: @user.email, subject: "Verify your email", template_name: "verification_email", content_type: "text/html")
    logger.info "✅ Email sent to #{@user.email}"
  end
end
