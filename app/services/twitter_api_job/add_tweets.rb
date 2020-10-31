module TwitterAPIJob
  class AddTweets
    include TwitterAPIClient
    attr_reader :notify_logs

    def initialize(registered_tags = RegisteredTag.all.includes(:user, :tag))
      @registered_tags = registered_tags
      @notify_logs = []
    end

    def call
      registered_tags.each do |r_tag|
        last_tweet = r_tag.tweets.latest
        unless last_tweet
          r_tag.create_tweets!
          next
        end

        next if last_tweet.tweeted_at > Time.current.prev_day.beginning_of_day

        since_id = last_tweet.tweet_id.to_i
        message = "@#{r_tag.user.screen_name} の ##{r_tag.tag.name} にツイートを追加"
        tweet_data = TwitterAPI::UserTweets.new(r_tag.user, r_tag.tag.name, since_id).call('everyday')
        r_tag.add_tweets(tweet_data).any? && notify_logs << message && Rails.logger.info(message)
      end
    end

    private

    attr_reader :registered_tags
  end
end
