# About
This app allows users to subscribe to a mailing list with their email and location. A script can then be run to send out customized emails based on the current weather at the location.

## Features

- client-side and server-side validation for user inputs
- comprehensive error handling
- an in-house client for interfacing with the Wunderground API complete with caching to minimize the number of calls we have to make and test specs.


# Setup
This project uses ruby-2.4.0

1. Bundle, create databases, and populate the `cities` table with top 100 cities by population:

  ```
  > bundle install
  > rake db:create
  > rake db:migrate
  > rake db:import_cities_from_csv
  ```

2. Create a file `config/settings.yml` and input your settings. See `config.settings-sample.yml` for an example.

3. Start server: `> rails s` then visit 'localhost:3000'.

4. Run tests: `> bundle exec rspec`


# Sending out emails
Run the following rake task to send out emails to every subscribed user. The subject line and content will be different depending on weather conditions at the user's location. Note that there is a delay between sending emails to abide by Wunderground's 5-calls-per-minute limit.

```
> rake mailer:send_weather_emails
```

