class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'
  def weather_email(email, city, state)
    @email = email
    @city = city
    @state = state
    @weather = WundergroundApiClient.conditions(@city, @state)

    mail(to: @email, subject: subject_line)
  end


  private

  def subject_line
    avg_temp = WundergroundApiClient.avg_temp(@city, @state)
    weather_feel = WundergroundApiClient.weather_feel(@weather[:weather], @weather[:temperature], avg_temp)

    case weather_feel
    when :good
      "It's nice out! Enjoy a discount on us."
    when :bad
      "Not so nice out? That's okay, enjoy a discount on us."
    when :average
      "Enjoy a discount on us."
    end
  end
end
