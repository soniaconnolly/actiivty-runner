require 'vcr'

require_relative '../activity_runner'
require_relative '../activity_factory'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :faraday
  # Do not write API keys into vcr cassettes
  # config.filter_sensitive_data('FAKE_SOME_API_KEY') { ENV['SOME_API_KEY'] }
end
