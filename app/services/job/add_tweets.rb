module Job
  class AddTweets
    include TwitterApiClient
    attr_reader :notify_logs

    def initialize(registered_tags = RegisteredTag.all.includes(:user, :tag))
      @registered_tags = registered_tags
      @notify_logs = []
    end

    def call
      registered_tags.each do |registered_tag|
        collect_tweets(registered_tag)
      end
    end

    private

    attr_reader :registered_tags

    def collect_tweets(registered_tag)
      collect(registered_tag, registered_tag.user)
    rescue TwitterApiClient::NotFoundAuthenticationError
      user = User.admin.first
      collect(registered_tag, user)
    rescue StandardError => e
      message = "@#{registered_tag.user.screen_name} の ##{registered_tag.tag.name}: #{e}"
      notify_logs << message && Rails.logger.error(message)
    end

    def collect(registered_tag, user)
      last_tweet = registered_tag.tweets.latest
      # 今日既にツイートしている場合はスルー
      return if last_tweet && last_tweet.tweeted_at > Time.current.prev_day.beginning_of_day

      if last_tweet
        since_id = last_tweet.tweet_id.to_i
        tweets_data = TwitterApi::UserTweets.new(user, registered_tag.tag.name, since_id)
                                            .call('everyday')
      else
        tweets_data = TwitterApi::UserTweets.new(user, registered_tag.tag.name).call
      end

      return if tweets_data.empty?

      registered_tag.create_tweets(tweets_data)
      message = "@#{registered_tag.user.screen_name} の ##{registered_tag.tag.name} にツイートを追加"
      notify_logs << message
      Rails.logger.info(message)
    end
  end
end
