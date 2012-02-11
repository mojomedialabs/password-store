class UserMailer < ActionMailer::Base
  default :from => "admin@teamrgc.com"

  def welcome(user)
    @user = user

    mail :to => user.email_address, :subject => "Welcome to the Mojo Media Labs Password Store!"
  end

  def password_reset(user)
    @user = user

    mail :to => user.email_address, :subject => "Mojo Media Labs Password Store - Password Reset"
  end
end
