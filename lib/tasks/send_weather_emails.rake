namespace :mailer do
  desc "send weather email to all users"
  task send_weather_emails: :environment do
    query = " SELECT email,
                cities.name AS city,
                cities.state
              FROM users
              JOIN cities
              ON city_id = cities.id;"
    users = ActiveRecord::Base.connection.exec_query(query).to_hash

    users.each do |user|
      UserMailer.weather_email(user['email'], user['city'], user['state']).deliver_now
    end
  end
end
