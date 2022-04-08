# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password access_token access_token_secret passw secret token _key crypt salt certificate otp ssn
]
