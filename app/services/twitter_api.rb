module TwitterAPI
  class RemindReply
    include TwitterAPIClient

    def initialize
      @registered_tags = RegisteredTag.all.includes(:user, :tag)
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
      Rails.logger.info("@#{r_tag.user.screen_name} の ##{r_tag.tag.name} にリマインドリプライ送信")
    end

    def remind_message(r_tag)
      day = r_tag.day_from_last_tweet == 1 ? '丸1日' : "#{r_tag.day_from_last_tweet}日間"
      url = "https://hashlog.work/mypage/tags/#{r_tag.id}"
      "@#{r_tag.user.screen_name}\n##{r_tag.tag.name} のツイートが#{day}途絶えているようです。調子はいかがですか？
\n通知を解除する場合は以下のリンクから設定してください。\n#{url}"
    end
  end

  class Search
    include TwitterAPIClient

    def initialize(user, tag_name, since_id = nil)
      @tweet_ids = []
      @tweeted_ats = []
      @tweet_oembeds = []
      @user = user
      @tag_name = tag_name
      @since_id = since_id
    end

    # return [["<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-13 07:13:39 UTC, 1249596597479956481],
    #         ["あ<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-12 01:54:07 UTC, 1249153794946011137]]
    def tweets_data(type = 'standard')
      case type
      when 'standard'
        standard_search
      when 'premium'
        premium_search
      when 'everyday'
        everyday_search
      end
      client.oembeds(tweet_ids, omit_script: true, hide_thread: true, lang: :ja)
            .take(100)
            .map do |oembed|
        oembed.html =~ %r{\" dir=\"ltr\">(.+)</p>}
        tweet_oembeds << $+
      end
      tweet_oembeds.zip(tweeted_ats, tweet_ids)
    end

    private

    attr_reader :user, :tag_name, :since_id, :tweet_ids, :tweeted_ats, :tweet_oembeds

    def standard_search
      @standard_search ||= begin
        client.search("##{tag_name} from:#{user.screen_name} exclude:retweets",
                      result_type: 'recent', count: 100).take(100).map do |result|
          tweeted_ats << result.created_at
          tweet_ids << result.id
        end
      end
    end

    def premium_search
      @premium_search ||= begin
        client.premium_search("##{tag_name} from:#{user.screen_name}",
                              { maxResults: 100 },
                              { product: '30day' }).take(100).map do |result|
          next if result.retweeted_status.present?

          tweeted_ats << result.created_at
          tweet_ids << result.id
        end
      end
    end

    def everyday_search
      @everyday_search ||= begin
        client.search("##{tag_name} from:#{user.screen_name} exclude:retweets",
                      result_type: 'recent', since_id: since_id).take(100).map do |result|
          tweeted_ats << result.created_at
          tweet_ids << result.id
        end
      end
    end
  end
end
