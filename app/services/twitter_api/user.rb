module TwitterApi
  class User
    def initialize(user)
      @user = user
    end

    def call
      avatar = twitter_data.profile_image_url_https
      avatar_url = "#{avatar.scheme}://#{avatar.host}#{avatar.path}"

      user.update!(
        name: twitter_data.name,
        screen_name: twitter_data.screen_name,
        avatar_url:
      )
    rescue Twitter::Error::NotFound, Twitter::Error::Unauthorized => e
      user.deleted!
      raise e
    end

    private

    attr_reader :user

    def twitter_data
      @twitter_data ||= TwitterApiClient.client(user).user(user_id: user.twitter_id)
    end
  end
end
