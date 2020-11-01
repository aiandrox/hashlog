module TwitterAPIJob
  class AddTweets
    include TwitterAPIClient
    attr_reader :notify_logs

    def initialize(registered_tags = RegisteredTag.all.includes(:user, :tag))
      @registered_tags = registered_tags
      @notify_logs = []
      @not_found_authentication_flag = false
    end

    def call
      registered_tags.each do |registered_tag|
        collect_tweets(registered_tag)
      end
    end

    private

    attr_accessor :not_found_authentication_flag
    attr_reader :registered_tags

    def collect_tweets(r_tag)
      last_tweet = r_tag.tweets.latest
      unless last_tweet
        tweets_data = TwitterAPI::UserTweets.new(user(r_tag), r_tag.tag.name).call
        r_tag.create_tweets(tweets_data)
        return
      end

      return if last_tweet.tweeted_at > Time.current.prev_day.beginning_of_day

      since_id = last_tweet.tweet_id.to_i
      tweet_data = TwitterAPI::UserTweets.new(user(r_tag), r_tag.tag.name, since_id)
                                         .call('everyday')
      message = "@#{r_tag.user.screen_name} の ##{r_tag.tag.name} にツイートを追加"
      r_tag.add_tweets(tweet_data).any? && notify_logs << message && Rails.logger.info(message)
    rescue TwitterAPIClient::NotFoundAuthenticationError
      not_found_authentication_flag = true
      retry
    rescue StandardError => e
      message = "@#{r_tag.user.screen_name} の ##{r_tag.tag.name}: #{e}"
      notify_logs << message && Rails.logger.error(message)
    end

    def user(regsitered_tag)
      @user ||= if not_found_authentication_flag
                  User.find_by!(twitter_id: '1242379749650907137')
                else
                  registered_tag.user
                end
    end
  end
end
