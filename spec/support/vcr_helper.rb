require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<API KEY>') { Rails.application.credentials.dig(:twitter, :key) || 'tekito' }
  c.filter_sensitive_data('<ACCESS TOKEN>') { Rails.application.credentials.dig(:twitter, :access_token) || 'tekito' }
end
