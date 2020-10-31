require 'twitter'

module TwitterAPIClient
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
    @access_token = if user.authentication.access_token
                      crypt.decrypt_and_verify(user.authentication.access_token)
                    else
                      Rails.application.credentials.twitter[:access_token]
                    end
  end

  def access_token_secret
    @access_token_secret = if user.authentication.access_token
                             crypt.decrypt_and_verify(user.authentication.access_token_secret)
                           else
                             Rails.application.credentials.twitter[:access_token_secret]
                           end
  end

  def crypt
    key_len = ActiveSupport::MessageEncryptor.key_len
    secret = Rails.application.key_generator.generate_key('salt', key_len)
    ActiveSupport::MessageEncryptor.new(secret)
  end
end
