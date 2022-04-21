module TwitterApi
  class UserTweets
    def initialize(user, tag_name, since_id = nil)
      @tweet_ids = []
      @tweeted_ats = []
      @medias_list = []
      @user = user
      @tag_name = tag_name
      @since_id = since_id
    end

    # return [["<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-13 07:13:39 UTC, 1249596597479956481],
    #         ["あ<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-12 01:54:07 UTC, 1249153794946011137]]
    def call
      push_tweet_result
      client.oembeds(tweet_ids, omit_script: true, hide_thread: true, lang: :ja)
                  .take(100)
                  .map do |oembed|
        oembed.html =~ %r{" dir="ltr">(.+)</p>}
        Regexp.last_match(-1)
      end.zip(tweeted_ats, tweet_ids, medias_list)
    end

    private

    attr_reader :user, :tag_name, :since_id, :tweet_ids, :tweeted_ats, :medias_list

    def all_tweets
      @all_tweets ||= begin
        if since_id
          client.user_timeline(user_id: user.twitter_id, count: 200, since_id: since_id)
        else
          client.user_timeline(user_id: user.twitter_id, count: 200)
        end
      end
    end

    def client
      @client ||= TwitterApiClient.client(user)
    end

    def push_tweet_result
      all_tweets.each do |result|
        push_tweet_data(result) if hashtag?(result)
      end
    end

    def hashtag?(result)
      result.hashtags.map(&:text).include?(tag_name)
    end

    def push_tweet_data(result)
      tweeted_ats << result.created_at
      tweet_ids << result.id
      medias_list << result.media
    end
  end
end
