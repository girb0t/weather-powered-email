require 'rest-client'
class WundergroundApiClient
  API_KEY= '199d199e57a50a1e'

  BASE_URL = 'https://api.wunderground.com/api/' + API_KEY

  def self.conditions(city, state)
    raw_json = conditions_raw(city, state)
    {
      weather: raw_json['current_observation']['weather'],
      temperature: raw_json['current_observation']['temp_f']
    }
  end

  def self.average_temperature(city, state)
    raw_json = almanac_raw(city, state)
    normal_high = raw_json['almanac']['temp_high']['normal']['F'].to_f
    normal_low = raw_json['almanac']['temp_low']['normal']['F'].to_f
    (normal_high + normal_low) / 2
  end

  def self.conditions_raw(city, state)
    get("#{BASE_URL}/conditions/q/#{state}/#{format_city(city)}.json")
  end

  def self.almanac_raw(city, state)
    get("#{BASE_URL}/almanac/q/#{state}/#{format_city(city)}.json")
  end

  private

  def self.get(url)
    response = try_cache(url) do
      RestClient.get(url)
    end

    JSON.parse(response)
  end

  def self.try_cache(url)
    cache_key = "wunderground/#{url}"
    cache_lifetime = 2.hours
    Rails.cache.fetch(cache_key, expires_in: cache_lifetime) do
      yield
    end
  end

  def self.format_city(city)
    city.gsub(' ', '_')
  end
end
