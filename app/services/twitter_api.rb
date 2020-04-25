require 'twitter'

module TwitterAPI
  class Client
    def initialize(user, tag_name)
      @tweet_ids = []
      @tweeted_ats = []
      @tweet_oembeds = []
      @user = user
      @tag_name = tag_name
      client
    end

    # return [["<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-13 07:13:39 UTC, 1249596597479956481],
    #         ["あ<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-12 01:54:07 UTC, 1249153794946011137]]
    def tweets_data
      standard_search
      client.oembeds(tweet_ids,
        omit_script: true,
        hide_thread: true,
        lang: :ja).take(100).map do |oembed|
        oembed.html =~ %r{\" dir=\"ltr\">(.+)</p>}
        tweet_oembeds << $+
      end
      tweet_oembeds.zip(tweeted_ats, tweet_ids)
    end

    private

    attr_reader :user, :tag_name, :tweet_ids, :tweeted_ats, :tweet_oembeds

    def standard_search
      @standard_search ||= begin
        client.search("##{tag_name} from:#{user.screen_name}",
                      result_type: 'recent').take(100).map do |result|
          tweeted_ats << result.created_at
          tweet_ids << result.id
        end
      end
    end

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
end