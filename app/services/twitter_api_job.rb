module TwitterAPIJob
  class RemindReply
    include TwitterAPIClient
    attr_reader :notify_logs

    def initialize(registered_tags = RegisteredTag.all.includes(:user, :tag))
      @registered_tags = registered_tags
      @notify_logs = []
    end

    def call
      registered_tags.each do |tag|
        send_tweet(tag) if tag.remind_day.positive? && tag.remind_day < tag.day_from_last_tweet
      end
    end

    private

    attr_reader :registered_tags

    def send_tweet(r_tag)
      client.update(remind_message(r_tag))
      message = "@#{r_tag.user.screen_name} の ##{r_tag.tag.name} にリマインド送信"
      Rails.logger.info(message)
      notify_logs << message
    end

    def remind_message(r_tag)
      day = r_tag.day_from_last_tweet == 1 ? '丸1日' : "#{r_tag.day_from_last_tweet}日間"
      url = "https://hashlog.work/mypage/tags/#{r_tag.id}"
      "@#{r_tag.user.screen_name}\n##{r_tag.tag.name} のツイートが#{day}途絶えているようです。調子はいかがですか？
\n通知を解除する場合は以下のリンクから設定してください。\n#{url}"
    end
  end

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
        r_tag.add_tweets(since_id).any? && notify_logs << message && Rails.logger.info(message)
      end
    end

    private

    attr_reader :registered_tags
  end
end
