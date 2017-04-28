require 'rails_helper'

describe WundergroundApiClient do
  let(:client) { WundergroundApiClient }

  describe '#self.weather_feel' do
    let(:avg_temp) { 20 }
    let(:above_avg_temp) { 25 }
    let(:below_avg_temp) { 15 }
    let(:clear_condition) { 'Clear' }
    let(:precipitation) { 'Light Rain' }
    let(:dry_not_clear) { 'Overcast' }

    it "returns :good for clear, average temp weather" do
      expect(client.weather_feel(clear_condition, avg_temp, avg_temp)).to be(:good)
    end

    it "returns :good for dry (but not clear_condition), above-avg temp weather" do
      expect(client.weather_feel(dry_not_clear, above_avg_temp, avg_temp)).to be(:good)
    end

    it "returns :bad for precipitating weather" do
      expect(client.weather_feel(precipitation, above_avg_temp, avg_temp)).to be(:bad)
    end

    it "returns :bad for below-avg temp weather" do
      expect(client.weather_feel(clear_condition, below_avg_temp, avg_temp)).to be(:bad)
    end

    it "returns :avg for dry (but not clear_condition), avg temp weather" do
      expect(client.weather_feel(dry_not_clear, avg_temp, avg_temp))
    end

    describe '#self.conditions' do
      conditions_response = JSON.parse(File.read("spec/fixtures/wu_conditions_raw_response.json"))
      before(:each) do
        allow(WundergroundApiClient).to receive(:conditions_raw).and_return(conditions_response)
      end
      let(:temp_from_fixture) { conditions_response['current_observation']['temp_f'] }
      let(:weather_from_fixture) {  conditions_response['current_observation']['weather'] }

      it "returns the correct weather" do
        expect(client.conditions('my_city', 'my_state')[:weather]).to eq(weather_from_fixture)
      end

      it "returns the correct temperature" do
        expect(client.conditions('my_city', 'my_state')[:temperature]).to eq(temp_from_fixture)
      end
    end

    describe '#self.avg_temp' do
      almanac_response = JSON.parse(File.read("spec/fixtures/wu_almanac_raw_response.json"))
      before(:each) do
        allow(WundergroundApiClient).to receive(:almanac_raw).and_return(almanac_response)
      end
      let(:hi_temp_from_fixture) { almanac_response['almanac']['temp_high']['normal']['F'].to_f }
      let(:low_temp_from_fixture) { almanac_response['almanac']['temp_low']['normal']['F'].to_f }

      it "returns the average of the hi and low temperatures" do
        avg_temp = (hi_temp_from_fixture + low_temp_from_fixture) / 2
        expect(client.avg_temp('my_city', 'my_state')).to eq(avg_temp)
      end
    end
  end
end
