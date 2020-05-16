require 'twitter'

module TwitterApiClient
  def client
    @client ||= begin
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.credentials.twitter[:key]
        config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
        config.access_token        = Rails.application.credentials.twitter[:access_token]
        config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
        # config.access_token        = @user.access_token || Rails.application.credentials.twitter[:access_token]
        # config.access_token_secret = @user.access_token_secret || Rails.application.credentials.twitter[:access_token_secret]
        config.dev_environment     = 'dev'
      end
    end
  end
end
