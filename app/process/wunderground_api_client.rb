require 'rest-client'
class WundergroundApiClient
  API_KEY= '199d199e57a50a1e'

  BASE_URL = 'https://api.wunderground.com/api/' + API_KEY

  def self.conditions(city, state)
    raw_json = conditions_raw(city, state)
    ap raw_json
  end

  def self.almanac(city, state)
    raw_json = almanac_raw(city, state)
    ap raw_json
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

    return JSON.parse(response)
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
