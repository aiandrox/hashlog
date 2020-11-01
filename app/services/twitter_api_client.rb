require 'twitter'

module TwitterAPIClient
  class NotFoundAuthenticationError < StandardError
  end

  def client(user = nil)
    @user = user
    @client ||= begin
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.credentials.twitter[:key]
        config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
        config.access_token        = access_token
        config.access_token_secret = access_token_secret
        config.dev_environment     = 'premium' # sandboxの名前
      end
    end
  end

  private

  attr_reader :user

  def access_token
    return @access_token = Rails.application.credentials.twitter[:access_token] unless user

    raise NotFoundAuthenticationError unless user.authentication

    @access_token = crypt.decrypt_and_verify(user.authentication.access_token)
  end

  def access_token_secret
    unless user
      return @access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
    end

    raise NotFoundAuthenticationError unless user.authentication

    @access_token_secret = crypt.decrypt_and_verify(user.authentication.access_token_secret)
  end

  def crypt
    key_len = ActiveSupport::MessageEncryptor.key_len
    secret = Rails.application.key_generator.generate_key('salt', key_len)
    ActiveSupport::MessageEncryptor.new(secret)
  end
end
