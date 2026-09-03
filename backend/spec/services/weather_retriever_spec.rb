require "rails_helper"

describe WeatherRetriever, :vcr do
  # Tomorrowiorb.forecast reads this at call time to build the request URL, and VCR
  # matches on that URL. It has to be the key the cassettes were recorded with, so
  # stub it here rather than depending on whatever TOMORROW_IO_KEY happens to hold.
  before { allow(Tomorrowiorb).to receive(:api_key).and_return("MY_MEGA_TOMORROW_IO_KEY") }

  around do |example|
    travel_to(Time.zone.local(2023, 12, 5, 12)) { example.run }
  end

  # The cassette was recorded for Minneapolis (America/Chicago) and carries the
  # six daily forecasts from 2023-12-05 to 2023-12-10.
  let(:date) { Date.parse "2023-12-05" }
  let(:cassete) { "#{described_class.name}/#{postal_code}" }
  let(:postal_code) { "55403" }

  def perform
    VCR.use_cassette cassete do
      described_class.get(date, postal_code)
    end
  end

  def concurrent_retrieval(forecast_body)
    first_forecast_started = Queue.new
    release_first_forecast = Queue.new
    second_forecast_started = Queue.new
    call_count = 0
    call_count_lock = Mutex.new
    response = Tomorrowiorb::TomorrowioResponse.new(200, {}, forecast_body)

    allow(Tomorrowiorb).to receive(:forecast) do
      this_call = call_count_lock.synchronize { call_count += 1 }

      if this_call == 1
        first_forecast_started << true
        release_first_forecast.pop
      else
        second_forecast_started << true
      end

      response
    end

    retrieve = lambda do
      ActiveRecord::Base.connection_pool.with_connection do
        described_class.get(date, postal_code)
      end
    end

    first_request = Thread.new { retrieve.call }
    first_forecast_started.pop
    second_request = Thread.new { retrieve.call }

    second_reached_vendor = begin
      Timeout.timeout(0.5) { second_forecast_started.pop }
      true
    rescue Timeout::Error
      false
    ensure
      release_first_forecast << true
    end

    {
      second_reached_vendor: second_reached_vendor,
      call_count: call_count,
      weathers: [first_request.value, second_request.value]
    }
  end

  context "no weather cached" do
    it { expect(perform).to be_a(Weather) }
    it { expect(perform).to be_persisted }
    it { expect { perform }.to change { Weather.count }.by(1) }

    it "stores the weather under the date that was asked for" do
      expect(perform.date).to eq(date)
    end

    it "stores the forecast for that date" do
      weather = perform

      expect(weather.icon).to eq("cloudy")
      expect(weather.summary).to eq("General conditions are cloudy, with an average temperature of -0.76.")
      expect(weather.temperature_min).to eq(-1.83)
      expect(weather.temperature_max).to eq(0.64)
      expect(weather.humidity).to eq(81)
      expect(weather.pressure).to eq(991.51)
      expect(weather.precip_intensity).to eq(0)
    end

    it "stores it against the position for the postal code" do
      expect(perform.position.postal_code).to eq(postal_code)
    end

    context "when the caller passes a time rather than a date" do
      let(:date) { DateTime.new(2023, 12, 5, 17, 43, 12) }

      it "stores the weather under that day" do
        expect(perform.date).to eq(Date.parse("2023-12-05"))
      end
    end

    context "for a later day in the forecast window" do
      let(:date) { Date.parse "2023-12-07" }

      it "stores that day's forecast, not the first day's" do
        weather = perform

        expect(weather.date).to eq(date)
        expect(weather.icon).to eq("clear-day")
        expect(weather.temperature_min).to eq(-1.87)
        expect(weather.temperature_max).to eq(8.17)
      end
    end
  end

  context "the weather is already cached" do
    let(:position) { VCR.use_cassette(cassete) { Position.create(postal_code: postal_code) } }
    let!(:weather) { create :weather, date: date, position_id: position.id }

    before { expect(Weather).not_to receive(:create) }
    before { expect(Geocoder).not_to receive(:search) }
    before { expect(Tomorrowiorb).not_to receive(:forecast) }

    it { expect(perform).to eq(weather) }
    it { expect { perform }.not_to change { Weather.count } }
  end

  context "historical weather is already cached" do
    let(:date) { Date.parse "2023-12-01" }
    let(:position) { VCR.use_cassette(cassete) { Position.create(postal_code: postal_code) } }
    let!(:weather) { create :weather, date: date, position_id: position.id }

    before { expect(Tomorrowiorb).not_to receive(:forecast) }

    it "returns the stored weather for an old check-in" do
      expect(perform).to eq(weather)
    end
  end

  context "weather is cached against a legacy position without coordinates" do
    let(:position) do
      Position.create!(postal_code: postal_code).tap do |record|
        record.update_columns(latitude: nil, longitude: nil)
      end
    end
    let!(:weather) { create :weather, date: date, position_id: position.id }

    before { expect(Tomorrowiorb).not_to receive(:forecast) }

    it "returns the stored weather without requiring coordinates" do
      expect(perform).to eq(weather)
    end
  end

  # The pre-fix retriever cached every forecast under the date the API answered
  # with instead of the date it was asked for, so the lookup above never hit, and
  # the second call tripped the date/position uniqueness validation and returned
  # an unsaved record whose nil id callers stored as "no weather".
  context "asking twice for the same date" do
    it "serves the second call from the cache" do
      first = perform
      second = perform

      expect(second).to be_persisted
      expect(second.id).to eq(first.id)
      expect(Weather.count).to eq(1)
    end
  end

  context "two requests arrive before the weather is cached", :js do
    let!(:position) { Position.create!(postal_code: postal_code) }
    let(:forecast_body) do
      {
        timelines: {
          daily: [
            {time: "2023-12-05T06:00:00Z", values: {
              weatherCodeMin: 1102, humidityAvg: 81.2, pressureSurfaceLevelAvg: 991.51,
              rainIntensityAvg: 0, sleetIntensityAvg: 0, snowIntensityAvg: 0,
              temperatureAvg: -0.76, temperatureMin: -1.83, temperatureMax: 0.64
            }}
          ]
        }
      }.to_json
    end

    it "does not hold the position lock while requesting the vendor forecast" do
      result = concurrent_retrieval(forecast_body)

      expect(result[:second_reached_vendor]).to be(true)
      expect(result[:call_count]).to eq(2)
      expect(result[:weathers].map(&:id).uniq.length).to eq(1)
      expect(Weather.where(date: date, position_id: position.id).count).to eq(1)
    end

    context "when the position is being created by the requests" do
      before { position.destroy! }

      it "creates one position and one weather record" do
        first_geocode_started = Queue.new
        release_first_geocode = Queue.new
        second_geocode_started = Queue.new
        geocode_count = 0
        geocode_count_lock = Mutex.new
        geocode_result = double(
          city: "Minneapolis", state: "Minnesota", province: nil,
          country: "United States", latitude: 44.967486, longitude: -93.2897678
        )
        response = Tomorrowiorb::TomorrowioResponse.new(200, {}, forecast_body)

        allow(Geocoder).to receive(:search) do
          this_call = geocode_count_lock.synchronize { geocode_count += 1 }

          if this_call == 1
            first_geocode_started << true
            release_first_geocode.pop
          else
            second_geocode_started << true
          end

          [geocode_result]
        end
        allow(Tomorrowiorb).to receive(:forecast).and_return(response)

        retrieve = lambda do
          ActiveRecord::Base.connection_pool.with_connection do
            described_class.get(date, postal_code)
          end
        end

        first_request = Thread.new { retrieve.call }
        first_geocode_started.pop
        second_request = Thread.new { retrieve.call }

        second_reached_geocoder = begin
          Timeout.timeout(0.5) { second_geocode_started.pop }
          true
        rescue Timeout::Error
          false
        ensure
          release_first_geocode << true
        end

        weathers = [first_request.value, second_request.value]
        resolved_positions = Position.where(postal_code: postal_code)

        expect(second_reached_geocoder).to be(false)
        expect(geocode_count).to eq(1)
        expect(weathers.map(&:id).uniq.length).to eq(1)
        expect(resolved_positions.count).to eq(1)
        expect(Weather.where(date: date, position_id: resolved_positions.first.id).count).to eq(1)
      end
    end
  end

  context "another date is already cached for the position" do
    let(:other_date) { Date.parse "2023-12-06" }

    it "stores and returns a persisted record for the new date" do
      cached = VCR.use_cassette(cassete) { described_class.get(other_date, postal_code) }
      weather = perform

      expect(weather).to be_persisted
      expect(weather.id).not_to eq(cached.id)
      expect(weather.date).to eq(date)
      expect(cached.reload.date).to eq(other_date)
    end
  end

  # The forecast endpoint only covers today onwards, so a back-filled check-in has
  # no forecast to store. Storing whatever the API did answer with would file
  # another day's weather under this date.
  context "the requested date is outside the forecast window" do
    let(:date) { Date.parse "2023-12-01" }

    before { expect(Tomorrowiorb).not_to receive(:forecast) }

    it { expect(perform).to be_nil }
    it { expect { perform }.not_to change { Weather.count } }
  end

  context "a future date is outside the forecast window" do
    let(:date) { Date.parse "2023-12-20" }
    let(:miss_cache) { ActiveSupport::Cache::MemoryStore.new }

    before { allow(Rails).to receive(:cache).and_return(miss_cache) }

    it "temporarily caches the miss instead of spending quota again" do
      expect(Tomorrowiorb).to receive(:forecast).once.and_call_original

      expect(perform).to be_nil
      expect(perform).to be_nil
    end
  end

  context "the position's day differs from the UTC day" do
    # Sydney is UTC+11 in December: the daily forecast stamped 2023-12-05T20:00:00Z
    # is 2023-12-06 there, and that is the date the check-in was filed under.
    let(:date) { Date.parse "2023-12-06" }
    let(:postal_code) { "2000" }

    let(:forecast_body) do
      {
        timelines: {
          daily: [
            {time: "2023-12-05T20:00:00Z", values: {
              weatherCodeMin: 4000, humidityAvg: 62.4, pressureSurfaceLevelAvg: 1011.2,
              rainIntensityAvg: 0.5, sleetIntensityAvg: 0, snowIntensityAvg: 0,
              temperatureAvg: 22.1, temperatureMin: 18.3, temperatureMax: 26.7
            }}
          ]
        }
      }.to_json
    end

    before do
      allow(Geocoder).to receive(:search).with(postal_code).and_return(
        [double(city: "Sydney", state: "New South Wales", province: nil, country: "Australia",
          latitude: -33.8688, longitude: 151.2093)]
      )
      allow(Tomorrowiorb).to receive(:forecast).and_return(
        Tomorrowiorb::TomorrowioResponse.new(200, {}, forecast_body)
      )
    end

    subject { described_class.get(date, postal_code) }

    it "stores the forecast under the local date" do
      expect(subject.date).to eq(date)
      expect(subject.icon).to eq("rain")
      expect(subject.temperature_max).to eq(26.7)
    end

    it "serves the next call for that date from the cache" do
      first = subject

      expect(described_class.get(date, postal_code).id).to eq(first.id)
    end
  end

  context "the postal code cannot be geocoded" do
    let(:postal_code) { "not a place" }

    before { allow(Geocoder).to receive(:search).with(postal_code).and_return([]) }
    before { expect(Tomorrowiorb).not_to receive(:forecast) }

    it { expect(described_class.get(date, postal_code)).to be_nil }

    it "does not write the submitted location to the application log" do
      expect(Rails.logger).to receive(:warn) do |message|
        expect(message).not_to include(postal_code)
      end

      described_class.get(date, postal_code)
    end
  end

  context "the forecast API fails" do
    before do
      allow(Tomorrowiorb).to receive(:forecast).and_return(
        Tomorrowiorb::TomorrowioResponse.new(429, {}, "rate limit exceeded")
      )
    end

    it "returns nothing rather than an unsaved record" do
      position = VCR.use_cassette(cassete) { Position.create(postal_code: postal_code) }

      expect(position).to be_persisted
      expect(described_class.get(date, postal_code)).to be_nil
      expect(Weather.count).to eq(0)
    end

    it "identifies the position without logging its location data" do
      position = VCR.use_cassette(cassete) { Position.create(postal_code: postal_code) }

      expect(Rails.logger).to receive(:warn) do |message|
        expect(message).to include("position #{position.id}")
        expect(message).not_to include(postal_code, position.latitude.to_s, position.longitude.to_s)
      end

      described_class.get(date, postal_code)
    end
  end
end
