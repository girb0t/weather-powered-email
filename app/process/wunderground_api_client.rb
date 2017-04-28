require 'rest-client'
class WundergroundApiClient
  settings = YAML.load_file("#{Rails.root}/config/settings.yml")[Rails.env]
  API_KEY= settings['wunderground_api_key']
  BASE_URL = 'https://api.wunderground.com/api/' + API_KEY

  # Current conditions from WU that have precipitation will contain the following words.
  # Note that volcanic ash, sand/dust storms do not qualify as 'precipitation' according to
  # the meteorological definition of the word.
  # Source: https://www.wunderground.com/weather/api/d/docs?d=resources/phrase-glossary&MR=1
  PRECIPITATION_GLOSSARY = [
    'Drizzle',
    'Rain',
    'Snow',
    'Ice',
    'Hail',
    'Thunderstorm',
    'Squalls',
    'Precipitation'
  ].freeze

  # Takes objective weather information and returns a subjective descriptor of the weather:
  # :good - (Clear && not below-avg temp) || (No Precipitation && above-avg temp)
  # :bad  - (Pricipitation || below-avg temp)
  # :average - all other cases
  def self.weather_feel(condition, current_temp, avg_temp)
    relative_temp = relative_temp(current_temp, avg_temp)

    if ((condition == 'Clear') && relative_temp != :below_avg) || (!precipitating?(condition) && relative_temp == :above_avg)
      :good
    elsif precipitating?(condition) || relative_temp == :below_avg
      :bad
    else
      :average
    end
  end

  def self.conditions(city, state)
    raw_json = conditions_raw(city, state)
    {
      weather: raw_json['current_observation']['weather'],
      temperature: raw_json['current_observation']['temp_f']
    }
  end

  # Get average temperature of given location this time of year
  def self.avg_temp(city, state)
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


  # Helper methods

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

  def self.relative_temp(current_temp, avg_temp)
    if current_temp >= avg_temp + 5
      :above_avg
    elsif current_temp <= avg_temp - 5
      :below_avg
    else
      :average
    end
  end

  def self.precipitating?(condition)
    PRECIPITATION_GLOSSARY.each do |precip|
      return true if condition.include?(precip)
    end
    return false
  end
end
