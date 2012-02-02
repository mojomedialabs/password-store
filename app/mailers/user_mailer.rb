class UserMailer < ActionMailer::Base
  default :from => "admin@teamrgc.com"

  def welcome(user)
    @user = user

    mail :to => user.email_address, :subject => "Welcome to the Assessment Tool!"
  end

  def password_reset(user)
    @user = user

    mail :to => user.email_address, :subject => "Assessment Tool - Password Reset"
  end

  def assessment_results(assessment, user)
    @assessment = assessment
    @user = user

    mail :to => user.email_address, :subject => "Your assessment results are here!"
  end

  def admin_assessment_results(assessment, user)
    @assessment = assessment
    @user = user

    mail :to => User.admins.map(&:email_address), :subject => "Assessment results are in for #{@user.full_name}!"
  end
end
