namespace :mailer do
  desc "send weather email to all users"
  task send_weather_emails: :environment do
    User.find_each(batch_size: 500) do |user|
      UserMailer.weather_email(user).deliver_now
    end
  end
end
