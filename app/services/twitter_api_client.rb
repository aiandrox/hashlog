require 'twitter'

module TwitterAPIClient
  def client(user = nil)
    set_token(user)
    @client ||= begin
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.credentials.twitter[:key]
        config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
        config.access_token        = access_token
        config.access_token_secret = access_token_secret
        config.dev_environment     = 'premium'
      end
    end
  end

  private

  attr_reader :access_token, :access_token_secret

  def set_token(user)
    if user.nil? || user.authentication.access_token.empty?
      @access_token = Rails.application.credentials.twitter[:access_token]
      @access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
    else
      @access_token = crypt.decrypt_and_verify(user.authentication.access_token)
      @access_token_secret = crypt.decrypt_and_verify(user.authentication.access_token_secret)
    end
  end

  def crypt
    key_len = ActiveSupport::MessageEncryptor.key_len
    secret = Rails.application.key_generator.generate_key('salt', key_len)
    ActiveSupport::MessageEncryptor.new(secret)
  end
end
