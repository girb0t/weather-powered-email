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
    success_count = 0
    fail_count = 0

    users.each do |user|
      begin
        UserMailer.weather_email(user['email'], user['city'], user['state']).deliver_now
        success_count += 1
        print '.'
      rescue => e
        fail_count += 1
        Rails.logger.error("Emails failed to send for #{user['email']}. Error:")
        Rails.logger.error(e)
        print 'X'
      end
      sleep(30) # So we don't hit the WU API cap of 5 calls per minute.
    end

    puts "#{success_count} emails successfully sent."
    puts "#{fail_count} emails failed to send. Check logs for details." if fail_count > 0
  end
end
