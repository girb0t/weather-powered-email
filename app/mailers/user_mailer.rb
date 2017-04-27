class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'
  def weather_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
