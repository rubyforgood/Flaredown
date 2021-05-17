require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.default_cassette_options = {allow_playback_repeats: true}
  # comment the following line when you want WebMock to suggest you to stub requests
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  c.ignore_localhost = true

  # Put placeholders instead of sensitive data in our cassettes
  c.filter_sensitive_data("<RECAPTCHA_SECRET_KEY>") { ENV["RECAPTCHA_SECRET_KEY"] }
end
