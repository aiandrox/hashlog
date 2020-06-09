require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<API KEY>') { Rails.application.credentials[:twitter][:key] }
  c.filter_sensitive_data('<API SECRET KEY>') { Rails.application.credentials[:twitter][:secret_key] }
  c.filter_sensitive_data('<ACCESS TOKEN>') { Rails.application.credentials[:twitter][:access_token] }
  c.filter_sensitive_data('<ACCESS TOKEN SECRET>') { Rails.application.credentials[:twitter][:access_token_secret] }
  c.filter_sensitive_data('<OAUTH SIGNATURE>') { Rails.application.credentials[:twitter][:oauth_signature] }
end
